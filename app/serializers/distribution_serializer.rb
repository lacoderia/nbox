class DistributionSerializer < ActiveModel::Serializer

  attributes :id, :height, :width, :description, :inactive_seats, :active_seats, :total_seats

  def active_seats
    Bicycle.to_bicycle_array(object.active_seats)
  end


end
