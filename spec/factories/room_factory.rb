FactoryGirl.define do

  factory :room, class: Room do
    association :venue, factory: :venue
    association :distribution, factory: :distribution
    description "Saloncito"
  end

end
