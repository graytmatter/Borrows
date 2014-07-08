class CategorylistsController < ApplicationController
  before_filter :authenticate

  def create
  	@category = Categorylist.create(categorylist_params)
  	redirect_to '/admin/itemlists'
  end

  def edit
    @category = Categorylist.find_by_id(params[:id])
  end

  def update
  	@category = Categorylist.find_by_id(params[:id])
  	if @category.update_attributes(categorylist_params)
  	  redirect_to '/admin/itemlists'
    else
      render 'edit'
    end
  end

  private

  def categorylist_params
  	params.require(:categorylist).permit(:name)
  end
end