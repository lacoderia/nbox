FactoryGirl.define do
  factory :role, class: Role do
    name 'user'
  end

  factory :role_super_admin, parent: :role do
    name 'super_admin'
  end
  
end

