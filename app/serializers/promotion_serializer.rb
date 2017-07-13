class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :coupon, :description, :amount, :active
end
