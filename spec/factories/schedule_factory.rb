FactoryGirl.define do

  factory :schedule, class: Schedule do
    datetime Time.zone.now
    free false
    association :room, factory: :room
    association :instructor, factory: :instructor
    association :schedule_type, factory: :schedule_type
  end

end
