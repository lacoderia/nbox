class ScheduleTypesController < ApiController
  
  def index
    begin
      schedule_types = ScheduleType.active
      render json: schedule_types 
    rescue Exception => e
      schedule_type = ScheduleType.new
      schedule_type.errors.add(:error_getting_schedule_types, e.message)
      render json: ErrorSerializer.serialize(schedule_type.errors), status: 500
    end
  end
end
