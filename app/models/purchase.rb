class Purchase < ActiveRecord::Base
  belongs_to :pack
  belongs_to :user

  scope :with_users, -> {joins(:user)}

  scope :with_users_and_appointments_and_bom_and_eom, -> {select("purchases.*, date_trunc('month', purchases.created_at) AS bom, (date_trunc('month', purchases.created_at) + INTERVAL '1 MONTH - 1 minute' ) AS eom").joins(:user)}

  def self.charge params, user
    
    pack = Pack.find(params[:pack_id])
    amount = params[:price].to_i * 100
    card = Card.find_by_uid(params[:uid]) 

    if not card
      raise "Tarjeta no encontrada o registrada."
    end
 
    description = pack.description
    currency = "MXN"
    credits = user.credits
    params_coupon = params[:coupon]
    params_credits = params[:credits]
    params_price = params[:price]

    if params_coupon and params_credits
      raise "Sólo se puede utilizar un método de descuento, cupón o créditos."
    end

    #Se valida el precio final con cupón
    if params_coupon
      validated_price = (Discount.validate_with_coupon_and_pack user, pack, params_coupon)[:final_price]
      description = "#{description} con cupón de descuento"
      
      if params_price.to_f != validated_price
        raise "El precio enviado es diferente al precio con descuento."
      end
    #Se valida el precio con créditos
    elsif params_credits
      price_and_credits = Discount.validate_with_credits_and_pack user, pack
      validated_price = price_and_credits[:final_price]
      credits = price_and_credits[:final_credits]
      description = "#{description} con crédito a favor"

      if params_credits.to_f != price_and_credits[:initial_credits] or params_price.to_f != validated_price 
        raise "Hay un error calculando el precio final con los créditos a favor."
      end
    elsif (pack.price_or_special_price_for_user user) != params_price.to_f
      raise "El precio enviado es diferente al precio del paquete."
    end

    if params_price.to_f > 0

      charge = Conekta::Charge.create({
        amount: amount,
        currency: currency,
        description: description,
        card: card.uid,
        details: {
          name: card.name,
          email: user.email,
          phone: card.phone,
          line_items: [{
            name: description,
            description: "Paquete nbox",
            unit_price: amount,
            quantity: 1
          }]
        }
      })

      purchase = Purchase.create!(
        user: user,
        pack: pack,
        uid: charge.id,
        object: charge.object, 
        livemode: charge.livemode, 
        status: charge.status,
        description: charge.description,
        amount: charge.amount,
        currency: charge.currency,
        payment_method: charge.payment_method,
        details: charge.details
      )

    else

      purchase = Purchase.create!(
        user: user,
        pack: pack,
        object: "charge", 
        livemode: true, 
        status: "paid",
        description: description,
        amount: amount,
        currency: currency,
        payment_method: "free",
        details: "pago gratis"
      )
      
    end

    if user.expiration_date
      if user.expiration_date <= Time.zone.now
        expiration_date = Time.zone.now + pack.expiration.days
      else
        expiration_date = user.expiration_date + pack.expiration.days
      end
    else
      expiration_date = Time.zone.now + pack.expiration.days
    end

    if params_coupon and referrer = User.find_by_coupon(params_coupon.upcase) 
      if not referrer.staff?
        #Add credit
        referrer.update_attribute(:credits, referrer.credits + Config.referral_credit) 
      end
      #Add referral
      Referral.create!(owner: referrer, referred: user, credits: Config.referral_credit, used: false)
      #Send email
      SendEmailJob.perform_later("shared_coupon", user, referrer)
    elsif params_coupon and promotion = Promotion.find_by_coupon(params_coupon.upcase)
      user.promotions << promotion
      user.save!
    end
    
    user.update_attributes(classes_left: (user.classes_left.nil? ? 0 : user.classes_left)  + pack.classes,
                            last_class_purchased: Time.zone.now,
                            expiration_date: expiration_date,
                            credits: credits)

    return purchase
    
  end
end
