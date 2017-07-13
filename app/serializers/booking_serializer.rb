module BookingSerializer

  def BookingSerializer.serialize(booked_seats)
    return if booked_seats.nil?

    bookings = {}
    bookings[:bookings] = {booked_seats: booked_seats}
    bookings
  end

end
