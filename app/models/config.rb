class Config < ActiveRecord::Base

  DEFAULT_DISCOUNT_AMOUNT = 40.00
  DEFAULT_REFERRAL_CREDIT = 40.00
  
  #Number of attendees for instructor payments
  DEFAULT_ZERO_TO_FOUR = 50.00
  DEFAULT_FIVE_TO_NINE = 150.00
  DEFAULT_TEN_TO_FOURTEEN = 250.00
  DEFAULT_FIFTEEN_TO_NINETEEN = 350.00
      
  #Default free classes date  
  DEFAULT_FREE_CLASSES_START_DATE = "2017-01-01T00:00:00-05:00"
  DEFAULT_FREE_CLASSES_END_DATE = "2017-01-01T00:00:01-05:00"

  #Default special prices in every purchase
  DEFAULT_SPECIAL_PRICES_IN_EVERY_PURCHASE_START_DATE = "2018-06-18T00:00:00-05:00"
  DEFAULT_SPECIAL_PRICES_IN_EVERY_PURCHASE_END_DATE = "2018-06-18T07:00:01-05:00"

  def self.force_special_price?
    special_prices_start_date = Config.find_by_key("special_prices_start_date")
    if special_prices_start_date
      special_prices_start_date = special_prices_start_date.value    
    else
      special_prices_start_date = DEFAULT_SPECIAL_PRICES_IN_EVERY_PURCHASE_START_DATE 
    end

    special_prices_end_date = Config.find_by_key("special_prices_end_date")
    if special_prices_end_date
      special_prices_end_date = special_prices_end_date.value    
    else
      special_prices_end_date = DEFAULT_SPECIAL_PRICES_IN_EVERY_PURCHASE_END_DATE 
    end
    
    if (Time.zone.now >= special_prices_start_date) and (Time.zone.now < special_prices_end_date)
      return true 
    else
      return false 
    end 

  end

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

  def self.free_classes_start_date
    free_classes_start_date = Config.find_by_key("free_classes_start_date")
    if free_classes_start_date
      return free_classes_start_date.value
    else
      return DEFAULT_FREE_CLASSES_START_DATE
    end
  end

  def self.free_classes_end_date
    free_classes_end_date = Config.find_by_key("free_classes_end_date")
    if free_classes_end_date
      return free_classes_end_date.value
    else
      return DEFAULT_FREE_CLASSES_END_DATE
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
