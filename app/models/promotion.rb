class Promotion < ActiveRecord::Base

  has_and_belongs_to_many :users
  
  before_save :capitalize_coupon

  private

    def capitalize_coupon
      self.coupon = self.coupon.upcase
    end

end
