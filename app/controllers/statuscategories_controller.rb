class StatuscategoriesController < ApplicationController
  before_filter :authenticate

  def create
  	@statuscategory = Statuscategory.create(statuscategory_params)
  	redirect_to '/admin/statuses'
  end

  def edit
    @statuscategory = Statuscategory.find_by_id(params[:id])
  end

  def update
  	@statuscategory = Statuscategory.find_by_id(params[:id])
  	if @statuscategory.update_attributes(statuscategory_params)
  	  redirect_to '/admin/statuses'
    else
      render 'edit'
    end
  end

  private

  def statuscategory_params
  	params.require(:statuscategory).permit(:name)
  end
end