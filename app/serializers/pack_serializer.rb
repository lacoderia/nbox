class PackSerializer < ActiveModel::Serializer
  attributes :id, :description, :classes, :price, :special_price, :active, :expiration
end
