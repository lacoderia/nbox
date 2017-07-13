class CardSerializer < ActiveModel::Serializer

  attributes :user_id, :uid, :active, :last4, :exp_month, :exp_year, :name, :address, :phone, :primary, :brand

end
