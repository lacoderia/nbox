class PackSerializer < ActiveModel::Serializer

  attributes :id, :description, :classes, :price, :special_price, :active, :expiration, :force_special_price

  def force_special_price
    Config.force_special_price?
  end

end
