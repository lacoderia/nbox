feature 'RegistrationsController' do
  include ActiveJob::TestHelper
  
  describe 'registration process' do
    context 'user creation' do 

      it 'successfully creates user, logout, valid and invalid login, existing and non-existing session' do
        new_user = { first_name: "test", last_name: "user", email: "test@user.com", password: "12345678", password_confirmation: "12345678" }
        
        # Validates user creation
        page = register_with_service new_user 
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eq new_user[:first_name]

        # Validates session after user creation
        # Gets headers
        access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers

        # Sets headers
        set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
        
        page = get_session 
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eql new_user[:first_name]
        expect(SendEmailJob).to have_been_enqueued.with("welcome", global_id(User.last), nil)
      
        perform_enqueued_jobs { SendEmailJob.perform_later("welcome", User.last, nil) } 
        
        logout

        # Validates invalid login with correct email
        page = login_with_service user = { email: new_user[:email], password: 'invalidpassword' }
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "El correo electrónico o la contraseña son incorrectos."

        # Validates invalid login with incorrect email
        page = login_with_service user = { email: "anotheremail@test.com", password: 'invalidpassword' }
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "El correo electrónico o la contraseña son incorrectos."
 
        # Validates correct login
        page = login_with_service user = { email: new_user[:email], password: new_user[:password] }
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eql new_user[:first_name]

        # Validates session after login 
        # Gets headers
        access_token_2, uid_2, client_2, expiry_2, token_type_2 = get_headers
        
        # Validates no session if no headers are passed in
        page = get_session 
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "No se ha iniciado sesión."

        # Sets headers
        set_headers access_token_2, uid_2, client_2, expiry_2, token_type_2
        page = get_session 
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eql new_user[:first_name]
        
      end

      it 'checks for error on duplicate users' do
        new_user = { first_name: "test", last_name: "user", email: "test@user.com", password: "12345678", password_confirmation: "12345678" }
        
        # Validates user creation
        page = register_with_service new_user
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eq new_user[:first_name]
        expect(SendEmailJob).to have_been_enqueued.with("welcome", global_id(User.last), nil)
        logout
        
        page = register_with_service new_user 
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "Ya existe un usuario registrado con ese correo electrónico."
      end
      
    end

  end

end
