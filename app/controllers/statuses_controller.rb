class StatusesController < ApplicationController
  before_filter :authenticate

  def create
  	@status = Status.create(status_params)
  	redirect_to '/admin/statuses'
  end

  def update
  	@status = Status.find_by_id(params[:id])
  	@status.update_attributes(status_params)
  	redirect_to '/admin/statuses'
  end

  def destroy_status
  	@status = Status.find_by_id(params[:id])
  	@status.update_attributes(status_meaning: "")
  	redirect_to '/admin/statuses'
  end

  def index
  	@all_status = Status.all
  	@status = Status.new
  end

  private

  def status_params
  	params.require(:status).permit(:status_meaning)
  end
end