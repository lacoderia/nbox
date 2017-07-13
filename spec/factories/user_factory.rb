FactoryGirl.define do
  
  factory :user, class: User do
    sequence(:email){ |n| "user-#{n}@nbici.com" }
    first_name 'Test'
    last_name 'User'
    password '12345678'
    password_confirmation '12345678'
    phone '55439810'
    roles {[FactoryGirl.create(:role)]}
    #Only modifications through the admin
    credit_modifications []

    trait :staff do
      staff true
    end
  end

end
