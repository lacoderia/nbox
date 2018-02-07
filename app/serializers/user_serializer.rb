class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid, :active, :phone, :coupon, :coupon_value, :credits, :test, :linked, :expiration_date

  def coupon_value
    Config.coupon_discount
  end
end
