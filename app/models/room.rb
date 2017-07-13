class Room < ActiveRecord::Base
  has_many :schedules
  belongs_to :venue
  belongs_to :distribution
end
