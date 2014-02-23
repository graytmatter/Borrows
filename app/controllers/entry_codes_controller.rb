class EntryCodesController < ApplicationController
  before_action :set_entry_code, only: [:show, :edit, :update, :destroy]

  # GET /entry_codes
  # GET /entry_codes.json
  def index
    @entry_codes = EntryCode.all
  end

  # GET /entry_codes/1
  # GET /entry_codes/1.json
  def show
  end

  # GET /entry_codes/new
  def new
    @entry_code = EntryCode.new
  end

  # GET /entry_codes/1/edit
  def edit
  end

  # POST /entry_codes
  # POST /entry_codes.json
  def create
    @entry_code = EntryCode.new(entry_code_params)

    respond_to do |format|
      if @entry_code.save
        format.html { redirect_to @entry_code, notice: 'Entry code was successfully created.' }
        format.json { render action: 'show', status: :created, location: @entry_code }
      else
        format.html { render action: 'new' }
        format.json { render json: @entry_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entry_codes/1
  # PATCH/PUT /entry_codes/1.json
  def update
    respond_to do |format|
      if @entry_code.update(entry_code_params)
        format.html { redirect_to @entry_code, notice: 'Entry code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_codes/1
  # DELETE /entry_codes/1.json
  def destroy
    @entry_code.destroy
    respond_to do |format|
      format.html { redirect_to entry_codes_url }
      format.json { head :no_content }
    end
  end

  # POST /entry_codes/guard
  def guard
  end

  # POST /entry_codes/access
  def access
    @entry_code = EntryCode.find_by(:code=>params[:entry_code])
    if @entry_code && @entry_code.active?
      # session[:block_path] set in ApplicationController#verify_entry_code
      dest = session[:blocked_path]
      session[:blocked_path] = nil
      # remember the code they used
      session[:entry_code] = params[:entry_code]
      redirect_to dest
    else
      flash[:code] = "Did not recognize code"
      redirect_to :action=>:guard
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_code
      @entry_code = EntryCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_code_params
      params.require(:entry_code).permit(:code, :active)
    end
end
