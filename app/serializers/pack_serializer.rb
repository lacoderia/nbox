class PackSerializer < ActiveModel::Serializer
  attributes :description, :classes, :price, :special_price, :active
end
