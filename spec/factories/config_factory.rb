FactoryGirl.define do
  
  factory :config, class: Config do

    trait :coupon_discount do
      key "coupon_discount"
      value "40"
    end

  end

end
