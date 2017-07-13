feature 'AppointmentsController' do
  include ActiveJob::TestHelper

  let!(:starting_datetime){Time.zone.parse('01 Jan 2016 00:00:00')}
  
  context 'Querying for appointments' do
    
    let!(:user_with_classes){create(:user)}
    let!(:user_with_no_classes){create(:user)}
    
    #Schedules
    let!(:future_sch_01){create(:schedule, datetime: starting_datetime + 1.hour, description: "futuro uno")}
    let!(:future_sch_02){create(:schedule, datetime: starting_datetime + 1.day)}
    let!(:future_sch_03){create(:schedule, datetime: starting_datetime + 6.days + 23.hours)}
    let!(:future_sch_04){create(:schedule, datetime: starting_datetime + 7.days)}

    let!(:past_sch_01){create(:schedule, datetime: starting_datetime - 1.hour)}
    let!(:past_sch_02){create(:schedule, datetime: starting_datetime - 1.day)}
    let!(:past_sch_03){create(:schedule, datetime: starting_datetime - 6.days)}
    let!(:past_sch_04){create(:schedule, datetime: starting_datetime - 7.days)}

    #Appointments
    let!(:future_app_01){create(:appointment, user: user_with_classes, schedule: future_sch_01, start: future_sch_01.datetime)}
    let!(:future_app_02){create(:appointment, :cancelled, user: user_with_classes, schedule: future_sch_02, start: future_sch_02.datetime)}
    let!(:future_app_03){create(:appointment, user: user_with_classes, schedule: future_sch_03, start: future_sch_03.datetime)}
    let!(:future_app_04){create(:appointment, user: user_with_classes, schedule: future_sch_04, start: future_sch_04.datetime)}

    let!(:past_app_01){create(:appointment, :finalized, user: user_with_classes, schedule: past_sch_01, start: past_sch_01.datetime)}
    let!(:past_app_02){create(:appointment, :finalized, user: user_with_classes, schedule: past_sch_02, start: past_sch_02.datetime)}
    let!(:past_app_03){create(:appointment, :finalized, user: user_with_classes, schedule: past_sch_03, start: past_sch_03.datetime)}
    let!(:past_app_04){create(:appointment, :finalized, user: user_with_classes, schedule: past_sch_04, start: past_sch_04.datetime)}

    before do
      Timecop.freeze(starting_datetime)
    end

    it 'should get historic and weekly appointments' do

      #Requires login
      visit weekly_scope_for_user_appointments_path
      expect(page.status_code).to be 401

      visit historic_for_user_appointments_path
      expect(page.status_code).to be 401

      #Login
      page = login_with_service user = { email: user_with_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Weekly scope
      visit weekly_scope_for_user_appointments_path
      response = JSON.parse(page.body)
      expect(response["appointments"].size).to eql 3
      expect(response["appointments"][0]["id"]).to eql future_app_01.id
      expect(response["appointments"][0]["schedule"]["description"]).to eql "futuro uno"
      expect(response["appointments"][1]["id"]).to eql future_app_02.id
      expect(response["appointments"][2]["id"]).to eql future_app_03.id
      
      #Historic appointments
      visit historic_for_user_appointments_path
      response = JSON.parse(page.body)
      expect(response["appointments"].size).to eql 4
      expect(response["appointments"][0]["id"]).to eql past_app_04.id
      expect(response["appointments"][1]["id"]).to eql past_app_03.id
      expect(response["appointments"][2]["id"]).to eql past_app_02.id
      expect(response["appointments"][3]["id"]).to eql past_app_01.id

      logout
      
      #Login with another user
      page = login_with_service user = { email: user_with_no_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      
      #Weekly scope
      visit weekly_scope_for_user_appointments_path
      response = JSON.parse(page.body)
      expect(response["appointments"]).to eql []

      #Historic appointments
      visit historic_for_user_appointments_path
      response = JSON.parse(page.body)
      expect(response["appointments"]).to eql []

    end

  end

  context 'Creating, editing, and cancelling appointments' do
  
    let!(:schedule) { create(:schedule, datetime: starting_datetime + 1.hour) }
    let!(:schedule_free) { create(:schedule, datetime: starting_datetime + 1.hour, free: true) }
    let!(:schedule_02) { create(:schedule, datetime: starting_datetime + 4.hour) }
    let!(:user_with_classes_left) { create(:user, classes_left: 2, last_class_purchased: starting_datetime) }
    let!(:user_with_no_classes_left) { create(:user, classes_left: 0, last_class_purchased: starting_datetime) }
    let!(:user_with_nil_classes_left) { create(:user) }

    before do
      Timecop.freeze(starting_datetime)
    end

    it 'should test that free schedules dont deduct credits and that no credits are required to book them ' do

      #User with credits
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule_free.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end

      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"
      user = User.find(response["appointment"]["user_id"])
      #No credits deducted
      expect(user.classes_left).to eql 2
      
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_classes_left, Appointment.last) }
      logout

      #User with no credits
      page = login_with_service user = { email: user_with_nil_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule_free.id, bicycle_number: 3, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end

      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 3
      expect(response["appointment"]["schedule"]["free"]).to eq true
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"
      user = User.find(response["appointment"]["user_id"])
      expect(user.classes_left).to eql nil
      
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_nil_classes_left), global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_nil_classes_left, Appointment.last) }

    end

    it 'should test that free schedules cant be booked twice by the same user' do

      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule_free.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end

      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"
      user = User.find(response["appointment"]["user_id"])
      #No credits deducted
      expect(user.classes_left).to eql 2
      
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_classes_left, Appointment.last) }

      #Can't book twice a free schedule
      new_appointment_request = {schedule_id: schedule_free.id, bicycle_number: 2, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end

      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Sólo puedes reservar un lugar en clases gratis."

      logout

    end

    it 'should test edit bicycle number in an appointment' do
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"
      user = User.find(response["appointment"]["user_id"])
      expect(user.classes_left).to eql 1
      
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_classes_left, Appointment.last) } 

      #Error editing bicycle number
      edit_bicycle_appointment_request = {bicycle_number: 6}
      with_rack_test_driver do
        page.driver.post edit_bicycle_number_appointment_path(appointment.id), edit_bicycle_appointment_request 
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Esa bicicleta no existe, por favor intenta nuevamente."

      edit_bicycle_appointment_request = {bicycle_number: 4}
      with_rack_test_driver do
        page.driver.post edit_bicycle_number_appointment_path(appointment.id), edit_bicycle_appointment_request 
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "La bicicleta ya fue reservada, por favor intenta con otra."

      edit_bicycle_appointment_request = {bicycle_number: 1}
      with_rack_test_driver do
        page.driver.post edit_bicycle_number_appointment_path(appointment.id), edit_bicycle_appointment_request 
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Sólo se pueden cambiar los lugares con al menos una hora de anticipación."

      Timecop.travel(starting_datetime - 1.hours)
      edit_bicycle_appointment_request = {bicycle_number: 1}
      with_rack_test_driver do
        page.driver.post edit_bicycle_number_appointment_path(appointment.id), edit_bicycle_appointment_request 
      end
      response = JSON.parse(page.body)
      expect(response["appointment"]["bicycle_number"]).to eql 1
      expect(response["appointment"]["schedule"]["id"]).to eql appointment.schedule.id

      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_classes_left, Appointment.last) } 

    end

    it 'should test cancel appointment conditions' do

      #Creating appointment
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"
      user = User.find(response["appointment"]["user_id"])
      expect(user.classes_left).to eql 1

      #Error cancelling appointment
      Timecop.travel(starting_datetime - 11.hours)
      
      visit cancel_appointment_path(appointment.id)
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Sólo se pueden cancelar clases con 12 horas de anticipación."

      #Error calling an appointment_id that doesn't exist
      visit cancel_appointment_path(2003)
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Clase no encontrada."

      #Success cancelling appointment
      Timecop.travel(starting_datetime - 11.hours - 1.minute)
      
      visit cancel_appointment_path(appointment.id)
      response = JSON.parse(page.body)
      user = User.find(response["appointment"]["user_id"])
      expect(user.classes_left).to eql 2
      expect(response["appointment"]["booked_seats"]).to eq []
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "CANCELLED"

    end

    it 'should expire appointments' do

      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"

      new_datetime = starting_datetime + 2.hours
      Timecop.travel(new_datetime)
      Appointment.finalize

      expect(SendEmailJob).to have_been_enqueued.with("after_first_class", global_id(user_with_classes_left),  global_id(Appointment.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("after_first_class", user_with_classes_left, Appointment.last) } 
      expect(Email.count).to eql 1
      
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "FINALIZED"

      another_appointment_request = {schedule_id: schedule_02.id, bicycle_number: 4, description: "Mi segunda clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, another_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"

      Timecop.travel(new_datetime + 3.hours)
      Appointment.finalize

      expect(Appointment.finalized.count).to eql 2
      expect {expect(SendEmailJob).to have_been_enqueued.with("after_first_class", global_id(user_with_classes_left),  global_id(Appointment.last))}.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      expect(Email.count).to eql 1
      
      #Can't book past schedules
      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 2, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La clase ya está fuera de horario."
      
    end

    it 'should create successfully an appointment and error on creating one with the same bicycle or with another user_id' do
      
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      user = User.find(user_with_classes_left.id)
      expect(user.classes_left).to be 1 
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))
      
      perform_enqueued_jobs { SendEmailJob.perform_later("booking", user_with_classes_left, Appointment.last) } 

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La bicicleta ya fue reservada, por favor intenta con otra."

    end

    it 'checks for errors on users with no classes left' do
      Timecop.travel(starting_datetime)
      #USER WITH NO SESSION
      with_rack_test_driver do
        page.driver.post book_appointments_path, {} 
      end
      expect(page.status_code).to be 401

      #USER WITH NO CLASSES LEFT
      page = login_with_service user = { email: user_with_no_classes_left[:email], password: "12345678" }
      new_appointment_request_no_classes = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_no_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Ya no tienes clases disponibles, adquiere más para continuar."
      logout

      #RECENTLY CREATED USER WITH NO CLASSES LEFT DEFINED
      page = login_with_service user = { email: user_with_nil_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      new_appointment_request_nil_classes = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_nil_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Ya no tienes clases disponibles, adquiere más para continuar."
      logout

      #UNEXISTANT SEAT TRYING TO BE BOOKED
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 5, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Esa bicicleta no existe, por favor intenta nuevamente."

    end
    
  end

end
