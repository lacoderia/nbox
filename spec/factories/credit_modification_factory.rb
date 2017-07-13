FactoryGirl.define do

  factory :credit_modification, class: CreditModification do
    credits 1
    reason "Test credit modification"
    association :pack, factory: :pack
    association :user, factory: :user
  end
  
end
