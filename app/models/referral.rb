class Referral < ActiveRecord::Base

  belongs_to :owner, :foreign_key => "owner_id", :class_name => "User"
  belongs_to :referred, :foreign_key => "referred_id", :class_name => "User"

end
