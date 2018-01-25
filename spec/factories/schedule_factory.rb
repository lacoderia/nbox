FactoryGirl.define do

  factory :schedule, class: Schedule do
    datetime Time.zone.now
    free false
    association :room, factory: :room
    association :instructor, factory: :instructor
    association :schedule_type, factory: :schedule_type

    trait :with_alternate_instructor do
      association :alternate_instructor, factory: :instructor
    end
  end

end
