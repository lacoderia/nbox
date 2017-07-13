class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  has_many :appointments, :dependent => :delete_all

  #scope :for_instructor_payments, -> {select("schedules.*, COUNT(appointments.*) as app_num").joins(:appointments, :instructor).where("appointments.status = ?", "FINALIZED").group("schedules.id").group_by{|schedule| schedule.datetime.to_date.to_s}}
  
  def self.weekly_scope
    start_day = Time.zone.now.beginning_of_day
    end_day = start_day + 8.days
    Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)
  end

  def bookings
    booked_bicycles = []
    active_bicycles = Bicycle.to_bicycle_array(self.room.distribution.active_seats)
    self.appointments.booked.each do |appointment|
      booked_bicycles << active_bicycles.find{|bicycle| bicycle.number == appointment.bicycle_number}
    end
    booked_bicycles.sort_by{|bicycle| bicycle.number}
  end
  
  def available_seats
    total_seats = self.room.distribution.total_seats
    booked_seats = self.appointments.booked.count
    return total_seats - booked_seats
  end

  def inactive_seats
    eval(self.room.distribution.inactive_seats)
  end

  def bicycle_exists? bicycle_number
    active_bicycles = Bicycle.to_bicycle_array(self.room.distribution.active_seats)
    if active_bicycles.find{|bicycle| bicycle.number == bicycle_number}
      return true
    else
      return false
    end    
  end
  
end
