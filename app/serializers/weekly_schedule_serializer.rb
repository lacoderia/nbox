module WeeklyScheduleSerializer

  def WeeklyScheduleSerializer.serialize(schedules_with_start_date)

    result = {}
    serializer = ActiveModel::Serializer.serializer_for(schedules_with_start_date[:schedules])
    serializer_instance = serializer.new(schedules_with_start_date[:schedules], {})
    result[:schedules] = serializer_instance 
    result[:start_day] = schedules_with_start_date[:start_day]
    result
  end

end
