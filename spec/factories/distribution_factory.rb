FactoryGirl.define do

  factory :distribution, class: Distribution do
    height 2
    width 2
    description "Cuadradito"
    inactive_seats "[]"
    active_seats "[{position:1, number:1, description: 'abs'},{position:2, number:2, description: 'costal'},{position:3, number:3, description: 'pera'},{position:4, number:4, description: 'trx'}]"
    total_seats 4
    painted_seat_positions "[{position: 1, style: 'left'},{position: 2, style: 'right'}]"
  end

end
