FactoryGirl.define do

  factory :promotion, class: Promotion do

    coupon "NBOX"
    description "test coupon"
    active true
    amount 100.00

    trait :inactive do
      coupon "NBOX_INACTIVE"
      active false
    end
    
  end

end
