class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule

  STATUSES = [
    'BOOKED',
    'CANCELLED',
    'FINALIZED',
    'ANOMALY'
  ]
  
  validates :status, inclusion: {in: STATUSES}
  
  state_machine :status, :initial => 'BOOKED' do
    transition 'BOOKED' => 'FINALIZED', on: :finalize
    transition 'BOOKED' => 'CANCELLED', on: :cancel
    transition 'FINALIZED' => 'ANOMALY', on: :report_anomaly
  end

  scope :today_with_users, -> {where("start >= ? AND start <= ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day).includes(:user, :schedule => :instructor)}
  scope :all_with_users_and_schedules, ->{includes(:user, :schedule => :instructor)}
  scope :not_cancelled_with_users_and_schedules, ->{where("status != ?", 'CANCELLED').includes(:user, :schedule => :instructor)}
  scope :booked, -> {where("status = ?", 'BOOKED')}
  scope :finalized, -> {where("status = ?", 'FINALIZED')}
  scope :cancelled, -> {where("status = ?", 'CANCELLED')}
  scope :not_cancelled, -> {where("status = ? OR status = ?", 'BOOKED', 'FINALIZED')}
  #scope :today_with_users, -> {where("true").includes(:user, :schedule=> :instructor)}

  def cancel_with_time_check current_user
    # temporary variables to check remotely the current user only once
    current_user_variables = {test: current_user.test, classes_left: current_user.classes_left, linked: current_user.linked}

    if current_user_variables[:test]
      if Time.zone.now < (self.start - 1.minute)
        self.cancel!
        if (not self.schedule.free) and current_user_variables[:classes_left]
          if self.schedule.opening 
            future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Config.free_classes_start_date, Config.free_classes_end_date, true)
            if not future_free_appointments.empty?
              if current_user_variables[:linked]
                #Remote update of classes left
                current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] + 1}) 
              else
                current_user.update_attribute(:classes_left, current_user_variables[:classes_left] + 1) 
              end
            end
          else
            if current_user_variables[:linked]
              #Remote update of classes left
              current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] + 1}) 
            else
              current_user.update_attribute(:classes_left, current_user_variables[:classes_left] + 1) 
            end
          end
        end
      else
        raise "Sólo se pueden cancelar clases con usuario de pruebas con 1 minuto de anticipación."
      end
    else
      if Time.zone.now < (self.start - 12.hours)
        self.cancel!
        if (not self.schedule.free) and current_user_variables[:classes_left]
          if self.schedule.opening 
            future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Config.free_classes_start_date, Config.free_classes_end_date, true)
            if not future_free_appointments.empty?
              if current_user_variables[:linked]
                #Remote update of classes left
                current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] + 1}) 
              else
                current_user.update_attribute(:classes_left, current_user_variables[:classes_left] + 1) 
              end
            end
          else
            if current_user_variables[:linked]
              #Remote update of classes left
              current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] + 1}) 
            else
              current_user.update_attribute(:classes_left, current_user_variables[:classes_left] + 1) 
            end
          end
        end
      else
        raise "Sólo se pueden cancelar clases con 12 horas de anticipación."
      end
    end
        
  end

  def edit_station_number station_number
    
    if not self.schedule.station_exists?(station_number)
      raise "Esa estación no existe, por favor intenta nuevamente."
    end
      
    if self.schedule.bookings.find{|station| station.number == station_number}
      raise "La estación ya fue reservada, por favor intenta con otra."
    end

    if Time.zone.now < (self.start - 1.hour)
      self.update_attribute(:station_number, station_number)
    else
      raise "Sólo se pueden cambiar los lugares con al menos una hora de anticipación."
    end
  end

  def self.finalize
    appointments_to_finalize = Appointment.where("status = ? AND start < ?", "BOOKED", Time.zone.now - 1.hour)
    appointments_to_finalize.each do |appointment|
      appointment.finalize!
      if appointment.user.appointments.finalized.count == 1
        SendEmailJob.perform_later("after_first_class", appointment.user, appointment)
      end
    end
  end

  def self.book params, current_user
    # temporary variables to check remotely the current user only once
    current_user_variables = {classes_left: current_user.classes_left, linked: current_user.linked}

    schedule = Schedule.find(params[:schedule_id])
    station_number = params[:station_number].to_i
    description = params[:description]
    appointment = Appointment.new
    
    if schedule.datetime <= Time.zone.now
      raise "La clase ya está fuera de horario."
    end
      
    if not schedule.station_exists?(station_number)
      raise "Esa estación no existe, por favor intenta nuevamente."
    end

    if (not schedule.bookings.find{|station| station.number == station_number})
      if schedule.opening
        future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Config.free_classes_start_date, Config.free_classes_end_date, true)
        if future_free_appointments.empty?
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, station_number: station_number, status: "BOOKED", start: schedule.datetime, description: description)
        else
          #The second opening class will be deducted
          if (current_user_variables[:classes_left] and current_user_variables[:classes_left] >= 1) and (not schedule.bookings.find{|station| station.number == station_number})
            schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, station_number: station_number, status: "BOOKED", start: schedule.datetime, description: description)      
            
            if current_user_variables[:linked]
              #Remote update of classes left
              current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] - 1}) 
            else
              current_user.update_attribute(:classes_left, current_user_variables[:classes_left] - 1)
            end

          elsif not current_user_variables[:classes_left] or current_user_variables[:classes_left] == 0 
            raise "Ya no tienes clases disponibles, adquiere más para continuar."
          elsif schedule.bookings.find{|station| station.number == station_number}
            raise "La estación ya fue reservada, por favor intenta con otra."
          end
        end

      elsif schedule.free
        free_appointments = current_user.appointments.booked.where("schedule_id = ?", schedule.id)
        if free_appointments.empty?
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, station_number: station_number, status: "BOOKED", start: schedule.datetime, description: description)
        else
          raise "Sólo puedes reservar un lugar en clases gratis."
        end
      else
        if (current_user_variables[:classes_left] and current_user_variables[:classes_left] >= 1) and (not schedule.bookings.find{|station| station.number == station_number})
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, station_number: station_number, status: "BOOKED", start: schedule.datetime, description: description)      
          
          if current_user_variables[:linked]
            #Remote update of classes left
            current_user.remote_update_attributes({'user[classes_left]' => current_user_variables[:classes_left] - 1}) 
          else
            current_user.update_attribute(:classes_left, current_user_variables[:classes_left] - 1)
          end

        elsif not current_user_variables[:classes_left] or current_user_variables[:classes_left] == 0 
          raise "Ya no tienes clases disponibles, adquiere más para continuar."
        elsif schedule.bookings.find{|station| station.number == station_number}
          raise "La estación ya fue reservada, por favor intenta con otra."
        end
      end
    else
      raise "La estación ya fue reservada, por favor intenta con otra."
    end
    
    appointment
  end

  def self.weekly_scope_for_user current_user
    start_day = Time.zone.now
    Appointment.where("user_id = ? AND start >= ?", current_user.id, start_day)
  end

  def self.historic_for_user current_user
    start_day = Time.zone.now
    Appointment.where("user_id = ? AND start < ?", current_user.id, start_day).limit(25).order(id: :desc)
  end
end
