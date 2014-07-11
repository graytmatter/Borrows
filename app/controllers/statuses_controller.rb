class StatusesController < ApplicationController
  before_filter :authenticate

  def create
  	@status = Status.create(status_params)
  	redirect_to '/admin/statuses'
  end

  def edit
    @status = Status.find_by_id(params[:id])
  end

  def update
  	@status = Status.find_by_id(params[:id])
  	if @status.update_attributes(status_params)
  	  redirect_to '/admin/statuses'
    else
      render 'edit'
    end
  end

  def index
  	@status = Status.new
  	@statuscategory = Statuscategory.new
  end

  private

  def status_params
  	params.require(:status).permit(:statuscategory_id, :name)
  end
end