class ScheduleForInstructor < Schedule
  scope :for_instructor, -> (id) {joins(:instructor).where("instructors.id = ?", id).includes(:appointments => :user)} 
end
