class InstructorSerializer < ActiveModel::Serializer

  attributes :id, :first_name, :last_name, :email, :picture, :picture_2, :quote, :bio, :active
  has_many :schedules, key: 'weekly_schedules'

  def schedules
    object.schedules.includes(:room).where("datetime >= ? AND datetime <= ?", Time.zone.now, Time.zone.now + 7.days)
  end
  
  def email
    object.admin_user.email
  end
  
end
