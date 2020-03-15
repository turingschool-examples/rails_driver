require 'rails_helper'

RSpec.describe 'Spec Harness' do
  def conn(uri)
    url = ENV['RAILS_ENGINE_DOMAIN'] + uri
    Faraday.new(url)
  end

  describe 'ReST endpoints' do
    it 'can get an item' do
      response = conn('/api/v1/items/179').get

      expected_attributes = {
        name: 'Item Qui Veritatis',
        description: 'Totam labore quia harum dicta eum consequatur qui. Corporis inventore consequatur. Illum facilis tempora nihil placeat rerum sint est. Placeat ut aut. Eligendi perspiciatis unde eum sapiente velit.',
        unit_price: 906.17,
        merchant_id: 9
      }

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq('179')

      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end

    it 'can get all items' do
      response = conn('/api/v1/items').get
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].length).to eq(2483)
      json[:data].each do |item|
        expect(item[:type]).to eq("item")
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
      end
    end

    it 'can create an item' do
      name = "Shiny Itemy Item"
      description = "It does a lot of things real good"
      unit_price = 5011.96
      merchant_id = 43

      body = {
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      response = conn('/api/v1/items').post do |request|
        request.body = body
      end

      json = JSON.parse(response.body, symbolize_names: true)

      new_item = json[:data]
      expect(new_item[:attributes][:name]).to eq(name)
      expect(new_item[:attributes][:description]).to eq(description)
      expect(new_item[:attributes][:unit_price]).to eq(unit_price)
      expect(new_item[:attributes][:merchant_id]).to eq(merchant_id)

      conn("/api/v1/items/#{new_item[:id]}").delete
    end

    it 'can update an item' do
      name = "Shiny Itemy Item"
      description = "It does a lot of things real good"
      unit_price = 5011
      merchant_id = 43

      body = {
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      response = conn('/api/v1/items/75').patch do |request|
        request.body = body
      end

      json = JSON.parse(response.body, symbolize_names: true)
      item = json[:data]
      expect(item[:attributes][:name]).to eq(name)
      expect(item[:attributes][:description]).to eq(description)
      expect(item[:attributes][:unit_price]).to eq(unit_price)
      expect(item[:attributes][:merchant_id]).to eq(merchant_id)

      original_body = {
        name: 'Item Autem Eligendi',
        description:'Aliquam dolores dolore voluptas nesciunt non praesentium. Eum nihil repellendus modi. Aut in expedita nesciunt. Ut aliquam dicta omnis voluptas.',
        unit_price: '29949',
        merchant_id: '3',
      }
      conn("/api/v1/items/").patch do |request|
        request.body = original_body
      end
    end
  end

  describe 'Relationships' do
    it 'can get items for a merchant' do
      response = conn('/api/v1/merchants/99/items').get
      json = JSON.parse(response.body, symbolize_names: true)
      expected_ids =
      [
        2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406,
        2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2416,
        2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426,
        2427, 2428, 2429, 2430, 2431, 2432, 2433, 2434, 2435, 2436,
        2437, 2438
      ]
      item_ids = json[:data].map do |item|
        item[:id].to_i
      end
      expect(item_ids.sort).to eq(expected_ids)
    end
  end

  describe "search endpoints" do
    it 'can find a list of merchants that contain a fragment, case insensitive' do
      response = conn('/api/v1/merchants/find_all?name=ILL').get

      json = JSON.parse(response.body, symbolize_names: true)

      names = json[:data].map do |merchant|
        merchant[:attributes][:name]
      end

      expect(names.sort).to eq(["Schiller, Barrows and Parker", "Tillman Group", "Williamson Group", "Williamson Group", "Willms and Sons"])
    end
  end

  describe 'business intelligence' do
    it 'can get merchants with most revenue' do
      response = conn("/api/v1/merchants/most_revenue?quantity=7").get
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].length).to eq(7)

      expect(json[:data][0][:attributes][:name]).to eq("Dicki-Bednar")
      expect(json[:data][0][:id]).to eq("14")

      expect(json[:data][3][:attributes][:name]).to eq("Rath, Gleason and Spencer")
      expect(json[:data][3][:id]).to eq("53")

      expect(json[:data][6][:attributes][:name]).to eq("Marvin, Renner and Bauch")
      expect(json[:data][6][:id]).to eq("49")
    end

    it 'can get merchants who have sold the most items' do
      response = conn("/api/v1/merchants/most_items?quantity=8").get

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].length).to eq(8)

      expect(json[:data][0][:attributes][:name]).to eq("Kassulke, O'Hara and Quitzon")
      expect(json[:data][0][:id]).to eq("89")

      expect(json[:data][3][:attributes][:name]).to eq("Thiel Inc")
      expect(json[:data][3][:id]).to eq("22")

      expect(json[:data][7][:attributes][:name]).to eq("Sporer, Christiansen and Connelly")
      expect(json[:data][7][:id]).to eq("56")
    end

    it 'can get revenue between two dates' do
      response = conn('/api/v1/revenue?start=2012-03-09&end=2012-03-24').get

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(43198765.58)
    end
  end
end
