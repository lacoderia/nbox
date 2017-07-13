class DiscountsController < ApiController
  include ErrorSerializer
  
  before_action :authenticate_user!, only: [:validate_with_coupon, :validate_with_credits]

  def validate_with_coupon
    begin
      discount = Discount.validate_with_coupon_and_pack_id(current_user, params[:pack_id], params[:coupon])
      render json: DiscountSerializer.serialize(discount)
    rescue Exception => e
      errors = {:error_validating_coupon => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  def validate_with_credits
    begin
      discount = Discount.validate_with_credits_and_pack_id(current_user, params[:pack_id])
      render json: DiscountSerializer.serialize(discount)
    rescue Exception => e
      errors = {:error_validating_coupon => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

end
