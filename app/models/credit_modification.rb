class CreditModification < ActiveRecord::Base
  belongs_to :user
  belongs_to :pack

  validates :credits, presence: true
  validates :reason, presence: true
end
