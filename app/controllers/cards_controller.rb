class CardsController < ApiController 
  include ErrorSerializer
  
  before_action :authenticate_user!, only: [:register_for_user, :delete_for_user, :set_primary_for_user, :get_primary_for_user, :get_all_for_user]

  def register_for_user
    begin
      card = Card.register_for_user(current_user, params[:token], params[:phone])
      render json: card
    rescue Exception => e
      card = Card.new
      card.errors.add(:error_registering_card, e.message)
      render json: ErrorSerializer.serialize(card.errors), status: 500
    end
  end

  def delete_for_user
    begin
      cards_left = Card.delete_for_user(current_user, params[:card_uid])
      render json: cards_left
    rescue Exception => e
      card = Card.new
      card.errors.add(:error_deleting_card, e.message)
      render json: ErrorSerializer.serialize(card.errors), status: 500
    end
  end

  def set_primary_for_user
    begin
      card = Card.set_primary_for_user(current_user, params[:card_uid])
      render json: card
    rescue Exception => e
      card = Card.new
      card.errors.add(:error_setting_primary_card, e.message)
      render json: ErrorSerializer.serialize(card.errors), status: 500      
    end
  end

  def get_primary_for_user
    card = Card.get_primary_for_user(current_user)
    render json: card
  end

  def get_all_for_user
    cards = Card.get_all_for_user(current_user)
    render json: cards
  end

end
