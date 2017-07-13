FactoryGirl.define do

  factory :card, class: Card do
    association :user, factory: :user
    uid "tok_test_visa_4242"
    object "card"
    active true
    last4 "4242"
    exp_month "12"
    exp_year "17"
    address "ADDRESS"
    name "Card Name"
    phone '56789123'
    primary false
    brand "VISA"

    trait :no_funds do
      uid "tok_test_insufficient_funds"
    end
    
    trait :master_card do
      uid "tok_test_mastercard_4444"
    end

    trait :visa_card_2 do
      uid "tok_test_visa_1881"
    end

    trait :master_card_2 do
      uid "tok_test_mastercard_5100"
    end

    trait :amex do
      uid "tok_test_amex_0005"
    end

    trait :amex_2 do
      uid "tok_test_amex_8431"
    end
  end

end
