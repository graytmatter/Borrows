class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      flash[:jumbo] = true
      RequestMailer.confirmation_email(@request, request.host_with_port).deliver
      redirect_to edit_request_path(@request.edit_id)
    else
      render 'new'
    end
  end

  def edit 
    @request = Request.find_by_edit_id(params[:edit_id])
  end

  def update
    @request = Request.find_by_edit_id(params[:edit_id])
    if @request.update_attributes(request_params)
      flash[:success] = "Your request was updated!"
      RequestMailer.update_email(@request, request.host_with_port).deliver
      redirect_to edit_request_path(@request.edit_id)
    else
      render 'edit'
    end
  end

  private
    def request_params
      params.require(:request).permit(:email, :item, :detail, :name)
    end
end
