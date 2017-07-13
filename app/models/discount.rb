class Discount 

  DELSTRS = "0OB81I"
  
  USER_COUPON_TYPE = "USER_COUPON"
  PROMOTION_COUPON_TYPE = "PROMOTION"
  
  def self.generate_coupon
    random = SecureRandom.hex
    coupon = (random.upcase.delete DELSTRS)[0..5]
    if not User.find_by_coupon(coupon)
      return coupon
    end
  end

  def self.exists? coupon
    if coupon
      promotion = Promotion.find_by_coupon_and_active(coupon, true)
      if not promotion
        user_coupon = User.find_by_coupon(coupon)
        if user_coupon
          return {coupon: user_coupon.coupon, type: USER_COUPON_TYPE, value: Config.coupon_discount}
        else
          return false
        end
      else
        return {coupon: promotion.coupon, type: PROMOTION_COUPON_TYPE, value: promotion.amount, id: promotion.id}
      end      
    else
      return false
    end
  end

  def self.validate_with_credits_and_pack_id current_user, pack_id
    if not pack = Pack.find_by_id(pack_id)
      raise "El paquete no existe."
    end

    self.validate_with_credits_and_pack current_user, pack
  end

  def self.validate_with_credits_and_pack current_user, pack
    return pack.price_with_credits_for_user current_user
  end

  def self.validate_with_coupon_and_pack_id current_user, pack_id, coupon
    if not pack = Pack.find_by_id(pack_id)
      raise "El paquete no existe."
    end 

    self.validate_with_coupon_and_pack current_user, pack, coupon
  end  

  def self.validate_with_coupon_and_pack current_user, pack, coupon
    coupon = coupon.upcase
    if current_user.coupon == coupon
      raise "No puedes usar tu propio cupón."
    end
    
    if meta_coupon = (Discount.exists? coupon)

      if meta_coupon[:type].eql? USER_COUPON_TYPE and Referral.find_by_referred_id(current_user.id)
        raise "Ya has usado un cupón de otro usuario anteriormente."
      elsif meta_coupon[:type].eql? PROMOTION_COUPON_TYPE and
        not current_user.promotions.where("user_id = ? AND promotion_id = ?", current_user.id, meta_coupon[:id]).empty?
        raise "Ya has usado este cupón anteriormente."
      end

      return pack.price_with_coupon_for_user current_user, meta_coupon
    else
      raise "El cupón no existe."
    end
  end

end
