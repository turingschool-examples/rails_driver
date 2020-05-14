class Admin::Merchants::SearchController < ApplicationController
  def index
    @search_term = params[:merchant_name]
    response = Faraday.get("#{ENV['RAILS_ENGINE_DOMAIN']}/api/v1/merchants/find_all?name=#{@search_term}")
    merchants_data = JSON.parse(response.body, symbolize_names: true)
    @merchants = merchants_data[:data].map do |merchant_data|
      Merchant.new(merchant_data)
    end
  end
end
