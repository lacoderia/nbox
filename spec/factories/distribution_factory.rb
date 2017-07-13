FactoryGirl.define do

  factory :distribution, class: Distribution do
    height 2
    width 2
    description "Cuadradito"
    inactive_seats "[]"
    active_seats "[{position:1, number:1},{position:2, number:2},{position:3, number:3},{position:4, number:4}]"
    total_seats 4
  end

end
