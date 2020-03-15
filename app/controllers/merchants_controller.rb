class MerchantsController < ApplicationController
  def show
    @merchant_id = params[:id]
  end
end
