class ExpirationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :classes_left, :last_class_purchased
end
