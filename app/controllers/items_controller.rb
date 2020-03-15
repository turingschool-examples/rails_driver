class ItemsController < ApplicationController
  def show
    @item_id = params[:id]
  end
end
