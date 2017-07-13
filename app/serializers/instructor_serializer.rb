class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :picture, :picture_2, :quote, :bio, :active, :weekly_schedules

  def email
    object.admin_user.email
  end
  
  def weekly_schedules
    object.schedules.includes(:room).where("datetime >= ? AND datetime <= ?", Time.zone.now, Time.zone.now + 7.days)
  end
end
