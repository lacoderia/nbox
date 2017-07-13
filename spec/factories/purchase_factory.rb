FactoryGirl.define do

  factory :purchase, class: Purchase do
    association :pack, factory: :pack 
    association :user, factory: :user
    uid "523dd8f6aef8784386000001"
    object "charge"
    livemode false
    status "paid"
    description "Stogies"
    amount 14000
    currency "MXN"
    payment_method "{'object':'card_payment', 'name':'Thomas Logan', 'exp_month':'12', 'exp_year':'15'}"
    details "{'name':'Arnulfo Quimare', 'phone':'403-342-0642', 'email':'logan@x-men.org'}"
  end

end
