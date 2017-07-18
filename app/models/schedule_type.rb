class ScheduleType < ApplicationRecord

  has_many :tiles

  scope :active, -> {where(active: true)}
 
end
