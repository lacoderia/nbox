feature 'InstructorsController' do
      
  let!(:starting_datetime) { Time.zone.parse('01 Jan 2016 00:00:00') }  
  
  let!(:instructor_01) { create(:instructor, quote: "YES EN INGLES") }
  let!(:instructor_02) { create(:instructor, quote: "OUI EN FRANCES") }
  let!(:schedule_01){ create(:schedule, instructor: instructor_01, datetime: starting_datetime + 1.hour) }
  let!(:schedule_02){ create(:schedule, instructor: instructor_01, datetime: starting_datetime + 7.days) }
  let!(:schedule_03){ create(:schedule, instructor: instructor_02, datetime: starting_datetime) }
  let!(:schedule_04){ create(:schedule, instructor: instructor_02, datetime: starting_datetime + 7.days + 1.minute) }

  context 'Get all instructors' do
    
    before do
      Timecop.freeze(starting_datetime)
    end

    it 'should get all the instructors' do
      visit instructors_path
      response = JSON.parse(page.body)
      expect(response["instructors"].count).to eql 2
      expect(response["instructors"][0]["quote"]).to eql "YES EN INGLES"
      expect(response["instructors"][1]["quote"]).to eql "OUI EN FRANCES"

      #For inactive instructors
      instructor_01.update_attribute(:active, false)
      visit instructors_path
      response = JSON.parse(page.body)
      expect(response["instructors"].count).to eql 1
      
    end

    it 'should get the instructors with the weeky schedules' do

      visit instructor_path(instructor_01.id)
      response = JSON.parse(page.body)
      expect(response["instructor"]["weekly_schedules"].count).to eql 2

      visit instructor_path(instructor_02.id)
      response = JSON.parse(page.body)
      expect(response["instructor"]["weekly_schedules"].count).to eql 1
      expect(response["instructor"]["weekly_schedules"][0]["id"]).to eql schedule_03.id

    end
  end

end
