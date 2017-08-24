class DistributionSerializer < ActiveModel::Serializer

  attributes :id, :height, :width, :description, :inactive_seats, :active_seats, :total_seats, :painted_seat_positions

  def active_seats
    Station.to_station_array(object.active_seats)
  end


end
