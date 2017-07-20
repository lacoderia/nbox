feature 'RemindersController' do
  include ActiveJob::TestHelper
  
  let(:starting_datetime){ Time.zone.parse('01 Jan 2016 13:00:00') }    

  context 'Tests classes left reminder conditions' do
  
    #FOR TESTING 1 REMAINING CLASS LEFT
    let!(:schedule) { create(:schedule) }
    let!(:user_with_1_classes_left) { create(:user, classes_left: 2) }
  
    it 'should get classes_left_reminder' do
      
      Timecop.travel(starting_datetime)
            
      expect(User.with_one_class_left.size).to eql 0

      #User makes a booking
      page = login_with_service user = { email: user_with_1_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, station_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end

      expect(User.with_one_class_left.size).to eql 1
      expect(User.with_one_class_left[0].id).to eql user_with_1_classes_left.id

      perform_enqueued_jobs { User.send_classes_left_reminder }
      
      #Shouldn't appear on query after the email being sent
      expect(User.with_one_class_left.size).to eql 0
      
      #Should appear on the query for next week
      Timecop.travel(starting_datetime + 7.days + 1.minute)
      expect(User.with_one_class_left.size).to eql 1
      
      perform_enqueued_jobs { User.send_classes_left_reminder }

      #Shouldn't appear on query after the email being sent
      expect(User.with_one_class_left.size).to eql 0      
    end
 
  end

  context 'Tests expiring classes reminder conditions' do

    #FOR TESTING EXPIRING CLASSES LEFT
    let!(:user_with_expiring_classes_30_days) { create(:user, classes_left: 2, last_class_purchased: starting_datetime) }
    let!(:card) { create(:card, user: user_with_expiring_classes_30_days) }
    let!(:user_with_expiring_classes_180_days) { create(:user, classes_left: 15, last_class_purchased: starting_datetime) }
    let!(:pack_30_days){ create(:pack, classes: 5, price: 650.00, expiration: 30) }
    let!(:purchase_01){ create(:purchase, pack: pack_30_days, user: user_with_expiring_classes_30_days, amount: 65000) }
    let!(:pack_180_days){ create(:pack, classes: 25, price: 2875.00, expiration: 180) }
    let!(:purchase_02){ create(:purchase, pack: pack_180_days, user: user_with_expiring_classes_180_days, amount: 287500) }

    it 'should get expiration_reminder', perform_enqueued: true do
      
      Timecop.travel(starting_datetime)
      
      expect(User.with_expiring_classes.size).to eql 0
      
      User.create_expiration_date_for_users_with_purchases
      #--Reminder for the 30 day pack
      Timecop.travel(starting_datetime + 28.days)
      expect(User.with_expiring_classes.size).to eql 1
      expect(User.with_expiring_classes[0].id).to eql user_with_expiring_classes_30_days.id

      perform_enqueued_jobs { User.send_expiration_reminder }      
      
      #Shouldn't appear on query after the email being sent
      expect(User.with_expiring_classes.size).to eql 0

      #It should expire classes
      Timecop.travel(starting_datetime + 30.days)
      expect(user_with_expiring_classes_30_days.classes_left).to eql 2
      expect(user_with_expiring_classes_30_days.purchases.last.expired).to eql false
      User.expire_classes
      expect(User.find(user_with_expiring_classes_30_days.id).classes_left).to eql 0
      expect(User.find(user_with_expiring_classes_30_days.id).expirations.count).to eql 1
      #expect(User.find(user_with_expiring_classes_30_days.id).purchases.last.expired).to eql true

      #It should not send another reminding email
      Timecop.travel(starting_datetime + 28.days + 7.days)
      expect(User.with_expiring_classes.size).to eql 0

      #--Reminder for the 180 day pack
      Timecop.travel(starting_datetime + 165.days)
      expect(User.with_expiring_classes.size).to eql 1
      expect(User.with_expiring_classes[0].id).to eql user_with_expiring_classes_180_days.id

      perform_enqueued_jobs { User.send_expiration_reminder }      
      
      #Shouldn't appear on query after the email being sent
      expect(User.with_expiring_classes.size).to eql 0

      #It shouldn't expire classes
      User.expire_classes
      expect(User.find(user_with_expiring_classes_180_days.id).classes_left).to eql 15
      expect(User.find(user_with_expiring_classes_180_days.id).expirations.count).to eql 0
      #expect(User.find(user_with_expiring_classes_180_days.id).purchases.last.expired).to eql false
      
      #It should send another reminding email
      Timecop.travel(starting_datetime + 172.days + 1.minute)

      #It should not send the email to a user that bought classes but they are not expiring 
      login_with_service user = { email: user_with_expiring_classes_30_days.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack_30_days.id, price: pack_30_days.price, token: card.uid}      
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(User.with_expiring_classes.size).to eql 1
      expect(User.with_expiring_classes[0].id).to eql user_with_expiring_classes_180_days.id
      
      perform_enqueued_jobs { User.send_expiration_reminder }      

      #Shouldn't appear on query after the email being sent
      expect(User.with_expiring_classes.size).to eql 0
      
      #It should expire classes
      Timecop.travel(starting_datetime + 180.days)
      expect(user_with_expiring_classes_180_days.classes_left).to eql 15
      expect(user_with_expiring_classes_180_days.purchases.last.expired).to eql false
      User.expire_classes
      expect(User.find(user_with_expiring_classes_180_days.id).classes_left).to eql 0
      expect(User.find(user_with_expiring_classes_180_days.id).expirations.count).to eql 1
      
      #It should not send another reminding email
      Timecop.travel(starting_datetime + 180.days + 1.days)
      expect(User.with_expiring_classes.size).to eql 0
      Timecop.travel(starting_datetime + 180.days + 7.days)
      expect(User.with_expiring_classes.size).to eql 0

    end
    

  end

end
