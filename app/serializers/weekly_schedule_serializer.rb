module WeeklyScheduleSerializer

  def WeeklyScheduleSerializer.serialize(schedules_with_start_date, with_instructor = true)

    result = {}
    serializer = ActiveModel::Serializer.serializer_for(schedules_with_start_date[:schedules])
    if with_instructor
      serializer_instance = serializer.new(schedules_with_start_date[:schedules], {})
    else
      serializer_instance = serializer.new(schedules_with_start_date[:schedules], {except: :instructor})
    end
    result[:schedules] = serializer_instance 
    result[:start_day] = schedules_with_start_date[:start_day]
    result
  end

end
