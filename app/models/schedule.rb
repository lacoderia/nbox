class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  belongs_to :schedule_type
  has_many :appointments, :dependent => :delete_all

  def self.weekly_scope
    start_day = Time.zone.now.beginning_of_day
    end_day = start_day + 8.days
    schedules = Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)

    #If thare are no schedules next week
    if schedules.empty?
      start_day = nil
      #Check if there are schedules anyday in the future
      schedules = Schedule.where("datetime >= ?", end_day).order(datetime: :asc)
      if not schedules.empty?
        start_day = schedules.first.datetime.beginning_of_day
        end_day = start_day + 8.days
        schedules = Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)
      end
    end

    return {schedules: schedules, start_day: start_day}
  end

  def bookings
    booked_stations = []
    active_stations  = Station.to_station_array(self.room.distribution.active_seats)
    self.appointments.booked.each do |appointment|
      booked_stations << active_stations.find{|station| station.number == appointment.station_number}
    end
    booked_stations.sort_by{|station| station.number}
  end
  
  def available_seats
    total_seats = self.room.distribution.total_seats
    booked_seats = self.appointments.booked.count
    return total_seats - booked_seats
  end

  def inactive_seats
    eval(self.room.distribution.inactive_seats)
  end

  def station_exists? station_number
    active_stations = Station.to_station_array(self.room.distribution.active_seats)
    if active_stations.find{|station| station.number == station_number}
      return true
    else
      return false
    end    
  end
  
end
