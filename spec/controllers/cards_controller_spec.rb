feature 'CardsController' do

  let!(:user_01){create(:user)}
  let!(:user_02){create(:user)}
  let!(:user_03){create(:user)}
  let!(:card_for_user_02){create(:card, user: user_02, uid: "tok_test_mastercard_4444", primary: true)}

  context 'REST api operations integrated with Conekta' do

    it 'should create and delete cards' do

      #Login
      page = login_with_service user = { email: user_01[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Creating 3 cards
      new_card_request = {token: 'tok_test_visa_4242', phone: '55864192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      response = JSON.parse(page.body)
      expect(response["card"]["last4"]).to eql "4242"
      expect(response["card"]["brand"]).to eql "VISA"

      new_card_request = {token: 'tok_test_amex_0005', phone: '55864192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      response = JSON.parse(page.body)
      expect(response["card"]["last4"]).to eql "0005"
      expect(response["card"]["brand"]).to eql "AMERICAN_EXPRESS"

      new_card_request = {token: 'tok_test_mastercard_5100', phone: '55864192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      response = JSON.parse(page.body)
      expect(response["card"]["last4"]).to eql "5100"
      expect(response["card"]["brand"]).to eql "MC"

      user = User.find(user_01.id)
      expect(user.cards.size).to eql 3
      expect(user.cards.first.primary).to eql true
      expect(user.cards.second.primary).to eql false
      expect(user.cards.last.primary).to eql false

      #Deleting cards and automatically swapping primary
      delete_card_request = {card_uid: user.cards.first.uid} 
      with_rack_test_driver do
        page.driver.post delete_for_user_cards_path, delete_card_request
      end
      response = JSON.parse(page.body)

      expect(response["cards"].size).to eql 2
      user = User.find(user_01.id)
      expect(user.cards.first.last4).to eql "0005"
      expect(user.cards.first.primary).to eql true
      expect(user.cards.last.last4).to eql "5100"
      expect(user.cards.last.primary).to eql false 

      #Changing primary card
      change_primary_request = {card_uid: user.cards.last.uid} 
      with_rack_test_driver do
        page.driver.post set_primary_for_user_cards_path, change_primary_request
      end
      response = JSON.parse(page.body)

      expect(response["card"]["last4"]).to eql "5100"
      user = User.find(user_01.id)
      expect(user.cards.first.last4).to eql "0005"
      expect(user.cards.first.primary).to eql false 
      expect(user.cards.last.last4).to eql "5100"
      expect(user.cards.last.primary).to eql true

      #Get primary card
      visit get_primary_for_user_cards_path
      response = JSON.parse(page.body)
      expect(response["card"]["last4"]).to eql "5100"

      #Get all cards
      visit get_all_for_user_cards_path
      response = JSON.parse(page.body)
      expect(response["cards"].size).to eql 2
      expect(response["cards"][0]["last4"]).to eql "0005"
      expect(response["cards"][1]["last4"]).to eql "5100"

      logout

      #Login with a user that has no cards registered
      page = login_with_service user = { email: user_03[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Get primary card
      visit get_primary_for_user_cards_path
      response = JSON.parse(page.body)
      expect(response).to be {}

      #Get all cards
      visit get_all_for_user_cards_path
      response = JSON.parse(page.body)
      expect(response["cards"]).to eql []

    end

    it 'should test all the errors thrown' do

      #Requires login
      new_card_request = {token: 'tok_test_visa_4242', phone: '55864192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      expect(page.status_code).to be 401

      #Login
      page = login_with_service user = { email: user_01[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Incorrect phone 
      new_card_request = {token: 'tok_test_visa_4242', phone: '558192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Validation failed: Phone is too short (minimum is 8 characters)"

      #Adding new card
      new_card_request = {token: 'tok_test_visa_4242', phone: '55864192'}
      with_rack_test_driver do
        page.driver.post register_for_user_cards_path, new_card_request
      end
      response = JSON.parse(page.body)
      expect(response["card"]["last4"]).to eql "4242"

      #Trying to delete the card
      user = User.find(user_01.id)
      delete_card_request = {card_uid: user.cards.first.uid} 
      with_rack_test_driver do
        page.driver.post delete_for_user_cards_path, delete_card_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Necesitas tener una tarjeta como mínimo."

      #Trying to modify a card that is not owned by the logged user
      change_primary_request = {card_uid: card_for_user_02.uid} 
      with_rack_test_driver do
        page.driver.post set_primary_for_user_cards_path, change_primary_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "No se puede modificar una tarjeta que no sea del usuario."

    end

  end

end
