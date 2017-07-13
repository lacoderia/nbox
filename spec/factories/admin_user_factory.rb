FactoryGirl.define do

  factory :admin_user, class: AdminUser do
    sequence(:email){ |n| "admin-#{n}@nbici.com" }
    password "password"
    password_confirmation "password"
    roles {[FactoryGirl.create(:role_super_admin)]}
    trait :with_instructor do
      association :instructor, factory: :instructor
    end
  end

end
