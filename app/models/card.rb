class Card < ActiveRecord::Base
  belongs_to :user

  validates :phone, length: { minimum: 8 }
  
  def self.register_for_user current_user, token, phone
    conekta_customer = current_user.get_or_create_conekta_customer
    conekta_card = conekta_customer.create_card(:token => token)
    card = Card.create!(user: current_user, uid: conekta_card.id, object: 'card', name: conekta_card.name, phone: phone, last4:conekta_card.last4, exp_month: conekta_card.exp_month, exp_year: conekta_card.exp_year, active: conekta_card.active, primary: current_user.cards.empty?, brand: conekta_card.brand)
    return card
  end

  def self.delete_for_user current_user, card_uid 

    if current_user.cards.size == 1
      raise "Necesitas tener una tarjeta como mínimo."
    end

    conekta_customer = current_user.get_or_create_conekta_customer
    conekta_cards = conekta_customer.cards
    conekta_cards.each do |index, conekta_card|
      if conekta_card.id == card_uid
        card = Card.find_by_uid(card_uid)
        if card.primary
          card.delete
          current_user.cards.first.update_attribute(:primary, true) 
        else
          card.delete
        end
        conekta_card.delete
        break
      end
    end
  
    return current_user.cards
  end
  
  def self.set_primary_for_user current_user, card_uid
    user_card = Card.find_by_uid(card_uid)
    if user_card.user_id != current_user.id
      raise "No se puede modificar una tarjeta que no sea del usuario."
    end
    Card.where("user_id = ?", user_card.user_id).update_all(:primary => false)
    user_card.update_attribute(:primary, true)
    return user_card
  end

  def self.get_primary_for_user current_user 
    cards = Card.where("user_id = ? and cards.primary = ?", current_user.id, true)
    if cards.empty?
      return {}
    else
      return cards.first
    end
  end

  def self.get_all_for_user current_user
    Card.where("user_id = ?", current_user.id)
  end

end
