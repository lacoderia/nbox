feature 'SchedulesController' do
      
  let!(:starting_datetime) { Time.zone.parse('01 Jan 2016 00:00:00') }  
  
  let!(:schedule_current_week_01) { create(:schedule, datetime: starting_datetime, description: "semana uno" ) }
  let!(:schedule_current_week_02) { create(:schedule, datetime: starting_datetime + 7.days + 23.hours + 59.minutes) }
  let!(:schedule_past_week) { create(:schedule, datetime: starting_datetime - 1.day) }
  let!(:schedule_next_week) { create(:schedule, datetime: starting_datetime + 8.days, free: true) }

  let!(:appointment_01) { create(:appointment, schedule: schedule_current_week_01, station_number: 4) }
  let!(:appointment_02) { create(:appointment, schedule: schedule_current_week_01, station_number: 1) }

  context 'Get weekly schedules' do

    before do
        Timecop.freeze(starting_datetime)
    end

    it 'should get the current week schedules' do

        visit weekly_scope_schedules_path
        response = JSON.parse(page.body)
        expect(response['schedules'].count).to eql 2
        expect(response['schedules'][0]["schedule_type"]).not_to be nil
        expect(response['schedules'][0]['id']).to eql schedule_current_week_01.id
        expect(response['schedules'][0]['description']).to eql "semana uno"
        expect(response['schedules'][1]['id']).to eql schedule_current_week_02.id
        expect(Schedule.count).to eql 4
        expect(response['schedules'][0]['available_seats']).to eql 2
        expect(response['schedules'][1]['available_seats']).to eql 4

        # Entrando la siguiente semana 
        one_week_after = starting_datetime + 8.days
        Timecop.travel(one_week_after)

        visit weekly_scope_schedules_path
        response = JSON.parse(page.body)
        expect(response['schedules'].count).to eql 1
        expect(response['schedules'][0]['id']).to eql schedule_next_week.id
        expect(response['schedules'][0]['free']).to eql true 
    end

    it 'should give the booked seats for a schedule' do

      visit bookings_schedule_path(schedule_current_week_01.id)
      response = JSON.parse(page.body)
      expect(response["bookings"]["booked_seats"][0]["number"]).to eql 1
      expect(response["bookings"]["booked_seats"][1]["number"]).to eql 4

    end

  end

end
