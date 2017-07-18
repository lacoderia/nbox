feature 'ScheduleTypesController' do

  let!(:user_01){create(:user)}
  let!(:schedule_type_01){create(:schedule_type)}
  let!(:schedule_type_02){create(:schedule_type, description: 'schedule_type_2')}
  let!(:schedule_type_03){create(:schedule_type, description: 'schedule_type_3', active: false)}
  
  context 'get schedule types' do

    it 'should get the schedule types' do

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      visit schedule_types_path 
      response = JSON.parse(page.body)
      expect(response["schedule_types"].length).to be 2
      expect(response["schedule_types"][0]["description"]).to eql schedule_type_01.description

      schedule_type_03.update_attribute(:active, true)

      visit schedule_types_path 
      response = JSON.parse(page.body)
      expect(response["schedule_types"].length).to be 3      

    end

    it 'should get error for not logged in' do

      visit schedule_types_path
      response = JSON.parse(page.body)
      expect(page.status_code).to be 401

    end

  end
  
end
