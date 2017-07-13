feature 'DiscountsController' do

  let!(:user_without_credits){create(:user)}
  let!(:user_with_credits){create(:user, credits: Config.referral_credit)}
  let!(:pack){create(:pack)}
  let!(:pack_with_discount){create(:pack, special_price: 100.00)}
  let!(:coupon_discount){create(:config, :coupon_discount)}
  let!(:promotion){create(:promotion)}
  let!(:promotion_mega){create(:promotion, amount: 1000, coupon: "nbicimega")}
  let!(:inactive_promotion){create(:promotion, :inactive, coupon: "INACTIVE")}

  context 'Coupon discount methods' do

    it 'should validate errors for discount' do

      login_with_service user = { email: user_without_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id + 100, coupon: user_without_credits.coupon.downcase}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El paquete no existe."

      validate_coupon_request = {pack_id: pack.id, coupon: user_without_credits.coupon + "F"}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El cupón no existe."

      #Inactive promotion
      validate_coupon_request = {pack_id: pack.id, coupon: inactive_promotion.coupon.upcase}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El cupón no existe."

      validate_coupon_request = {pack_id: pack.id, coupon: user_without_credits.coupon.downcase}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "No puedes usar tu propio cupón."

      Referral.create!(owner: user_with_credits, referred: user_without_credits, credits: Config.referral_credit, used: false)
      validate_coupon_request = {pack_id: pack.id, coupon: user_with_credits.coupon.upcase}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Ya has usado un cupón de otro usuario anteriormente."

      user_without_credits.promotions << promotion
      user_without_credits.save!

      validate_coupon_request = {pack_id: pack.id, coupon: promotion.coupon.downcase}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Ya has usado este cupón anteriormente."

    end

    it 'should validate prices for discount' do

      login_with_service user = { email: user_without_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id, coupon: user_with_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_with_credits.coupon
      expect(response["discount"]["final_price"]).to eq (pack.price - Config.coupon_discount)

      validate_coupon_request = {pack_id: pack_with_discount.id, coupon: user_with_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_with_credits.coupon
      expect(response["discount"]["final_price"]).to eq (pack_with_discount.special_price - Config.coupon_discount)

      #Generic coupon
      validate_coupon_request = {pack_id: pack.id, coupon: promotion.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq promotion.coupon
      expect(response["discount"]["final_price"]).to eq (pack.price - promotion.amount)

      #Generic meta coupon
      validate_coupon_request = {pack_id: pack.id, coupon: promotion_mega.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq promotion_mega.coupon
      expect(response["discount"]["final_price"]).to eq 0 
      expect(response["discount"]["discount"]).to eq pack.price

    end

  end

  context 'Credit discount methods' do

    it 'should validate errors for credits' do

      login_with_service user = { email: user_with_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_credit_request = {pack_id: pack.id + 100}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El paquete no existe."

    end

    it 'should validate prices for credits' do

      login_with_service user = { email: user_with_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_credit_request = {pack_id: pack.id}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["initial_price"]).to eql pack.price
      expect(response["discount"]["final_price"]).to eql pack.price - Config.referral_credit
      expect(response["discount"]["final_credits"]).to eql 0.0

      validate_credit_request = {pack_id: pack_with_discount.id}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["initial_price"]).to eql pack_with_discount.special_price
      expect(response["discount"]["final_price"]).to eql pack_with_discount.special_price - Config.referral_credit
      expect(response["discount"]["final_credits"]).to eql 0.0

      user_with_credits.update_attribute(:credits, Config.referral_credit * 10) 
      validate_credit_request = {pack_id: pack.id}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["initial_price"]).to eql pack.price
      expect(response["discount"]["final_price"]).to eql 0.0 
      expect(response["discount"]["final_credits"]).to eql ((Config.referral_credit * 10) - pack.price)

    end

  end
end
