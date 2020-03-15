class Admin::MerchantsController < ApplicationController
  def show
    @merchant_id = params[:id]
  end

  def edit
    @merchant_id = params[:id]
  end
end
