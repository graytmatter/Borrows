class ItemlistsController < ApplicationController
  before_filter :authenticate

  def create
  	@item = Itemlist.create(itemlist_params)
  	redirect_to '/admin/itemlists'
  end

  def edit
    @item = Itemlist.find_by_id(params[:id])
  end

  def update
  	@item = Itemlist.find_by_id(params[:id])
  	if @item.update_attributes(itemlist_params)
  	  redirect_to '/admin/itemlists'
    else
      render 'edit'
    end
  end

  def index
    @item = Itemlist.new
    @category = Categorylist.new
  end

  private

  def itemlist_params
  	params.require(:itemlist).permit(:categorylist_id, :name, :request_list, :inventory_list)
  end
end