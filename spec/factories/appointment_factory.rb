FactoryGirl.define do

  factory :appointment, class: Appointment do
    association :user, factory: :user
    status "BOOKED"
    association :schedule, factory: :schedule
    station_number 4
    start Time.zone.now
    description "Buena clase"
    
    trait :cancelled do
      status "CANCELLED"
    end
    
    trait :finalized do
      status "FINALIZED"
    end

  end 

end
