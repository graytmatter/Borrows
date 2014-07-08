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
  	@categories = Itemlist.all.pluck("category").uniq
    @item = Itemlist.new
  end

  private

  def itemlist_params
  	params.require(:itemlist).permit(:category, :name, :request_list, :inventory_list)
  end
end