feature 'DistributionsController' do
      
  let!(:distribution) { create(:distribution, description: "controller test") }
  let!(:room) { create(:room, distribution: distribution) }

  context 'Get distribution by room id' do

    it 'should get the room distribution' do
      visit "#{by_room_id_distributions_path}?room_id=#{room.id}"
      response = JSON.parse(page.body)
      expect(response["distribution"]["description"]).to eql "controller test"
      expect(response["distribution"]["active_seats"][0]["description"]).to eql "abs"
      expect(response["distribution"]["painted_seat_positions"]).to eql "[{position: 1, style: 'left'},{position: 2, style: 'right'}]"
    end

    it 'should error when room id is incorrect' do
      visit "#{by_room_id_distributions_path}?room_id=#{room.id + 1000}"
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "No hay salón con ese id."
    end
  end

end
