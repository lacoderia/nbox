class PurchasesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!, only: [:charge]

  # POST /purchases/charge
  def charge
    begin
      purchase = Purchase.charge(params, current_user)
      SendEmailJob.perform_later("purchase", current_user, purchase)
      render json: purchase
    rescue Exception => e
      purchase = Purchase.new
      if e.try(:message_to_purchaser)
        error = e.message_to_purchaser
      else
        error = e.message
      end
      purchase.errors.add(:error_creating_purchase, error)
      render json: ErrorSerializer.serialize(purchase.errors), status: 500
    end

  end
  
end
