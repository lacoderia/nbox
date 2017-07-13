FactoryGirl.define do

  factory :pack, class: Pack do
    description 'test pack'
    classes 1
    price 140.00
    expiration 15
  end

end
