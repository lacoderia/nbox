class ReferralSerializer < ActiveModel::Serializer
  attributes :id, :owner_id, :referred_id, :credits, :used
end
