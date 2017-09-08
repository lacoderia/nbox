class ScheduleSerializer < ActiveModel::Serializer

  attributes :id, :datetime, :room, :instructor, :available_seats, :description, :free, :schedule_type

  def room
    room_obj = {}
    room_obj[:id] = object.room.id
    room_obj[:description] = object.room.description
    room_obj[:venue] = object.room.venue
    room_obj
  end

  def available_seats
    if object.instructor
      return object.available_seats
    else
      return 0
    end
  end
  
  def instructor
    if object.instructor
      instructor_obj = {}
      instructor_obj[:id] = object.instructor.id
      instructor_obj[:first_name] = object.instructor.first_name
      instructor_obj[:last_name] = object.instructor.last_name
      return instructor_obj
    end
  end

end
