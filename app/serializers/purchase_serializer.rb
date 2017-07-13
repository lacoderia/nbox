class PurchaseSerializer < ActiveModel::Serializer

  attributes :id, :user, :pack_id, :uid, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details

  def user
    object.user
  end

end
