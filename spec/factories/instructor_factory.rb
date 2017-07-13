FactoryGirl.define do

  factory :instructor, class: Instructor do
    first_name 'Morenazo'
    last_name "Nazo"
    picture "picture_url"
    picture_2 "picture_2_url"
    quote "Hola"
    bio "Soy buenísimo"
    active true
    after(:create) do |instructor, evaluator|
      create_list(:admin_user, 1, :with_instructor, instructor: instructor)
    end
  end

end
