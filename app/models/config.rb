class Config < ActiveRecord::Base

  DEFAULT_DISCOUNT_AMOUNT = 40.00
  DEFAULT_REFERRAL_CREDIT = 40.00
  
  #Number of attendees for instructor payments
  DEFAULT_ZERO_TO_FOUR = 50.00
  DEFAULT_FIVE_TO_NINE = 150.00
  DEFAULT_TEN_TO_FOURTEEN = 250.00
  DEFAULT_FIFTEEN_TO_NINETEEN = 350.00

  def self.coupon_discount
    coupon_discount = Config.find_by_key("coupon_discount")
    if coupon_discount
      return coupon_discount.value.to_f
    else
      return DEFAULT_DISCOUNT_AMOUNT
    end
  end

  def self.referral_credit
    referral_credit = Config.find_by_key("referral_credit")
    if referral_credit
      return referral_credit.value.to_f
    else
      return DEFAULT_REFERRAL_CREDIT
    end
  end

  def self.payment_based_on_attendees attendees
   
    case attendees
    when 0..4
      zero_to_four = Config.find_by_key("zero_to_four")
      if zero_to_four
        zero_to_four.value.to_f
      else
        return DEFAULT_ZERO_TO_FOUR
      end 
    when 5..9
      five_to_nine = Config.find_by_key("five_to_nine")
      if five_to_nine
        five_to_nine.value.to_f
      else
        return DEFAULT_FIVE_TO_NINE
      end
    when 10..14
      ten_to_fourteen = Config.find_by_key("ten_to_fourteen")
      if ten_to_fourteen
        ten_to_fourteen.value.to_f
      else
        return DEFAULT_TEN_TO_FOURTEEN
      end
    when 15..19
      fifteen_to_nineteen = Config.find_by_key("fifteen_to_nineteen")
      if fifteen_to_nineteen
        fifteen_to_nineteen.value.to_f
      else
        return DEFAULT_FIFTEEN_TO_NINETEEN
      end      
    else
      raise "Número de asistentes no soportado."
    end
    
  end

end
