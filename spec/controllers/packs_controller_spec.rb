feature 'PacksController' do

  let!(:pack_1) { create(:pack, description: "1 clase", classes: 1, price: 300.00, special_price: 200.00) }
  let!(:pack_2) { create(:pack, description: "5 clases", classes: 5, price: 1450.00) }
  let!(:pack_3) { create(:pack, description: "10 clases", classes: 10, price: 2800.00) }
  let!(:pack_4) { create(:pack, description: "25 clases", classes: 25, price: 6250.00) }
  let!(:pack_5) { create(:pack, description: "50 clases", classes: 50, price: 10000.00, active: false) }

  context 'Get packs normally' do
  
    let!(:special_price_off_start_date) { create(:config, key: "special_prices_start_date", value: Time.zone.now - 2.hour ) }
    let!(:special_price_off_end_date) { create(:config, key: "special_prices_end_date", value: Time.zone.now - 1.hour ) }

    it 'should get the available packs' do

        visit packs_path
        response = JSON.parse(page.body)
        expect(response['packs'].count).to eql 4
        expect(response['packs'][0]['classes']).to eql 1
        expect(response['packs'][0]['force_special_price']).to eql false
      
    end

  end

  context 'Get packs forcing special prices' do
  
    let!(:special_price_on_start_date) { create(:config, key: "special_prices_start_date", value: Time.zone.now ) }
    let!(:special_price_on_end_date) { create(:config, key: "special_prices_end_date", value: Time.zone.now + 1.hour ) }

    it 'should get the available packs' do

        visit packs_path
        response = JSON.parse(page.body)
        expect(response['packs'].count).to eql 4
        expect(response['packs'][0]['classes']).to eql 1
        expect(response['packs'][0]['force_special_price']).to eql true 
      
    end

  end
end
