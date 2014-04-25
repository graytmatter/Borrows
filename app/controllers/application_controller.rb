class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # ensure that user has valid entry code
  def verify_entry_code
    if session[:entry_code] &&
        EntryCode.find_by(:code=>session[:entry_code]).active?
      return
    end
    session[:entry_code] = nil  # in case it was deactivated
    session[:blocked_path] = request.path  # where they were headed
    redirect_to guard_entry_codes_path
  end

  def howto 
    @howtoimages = {
      "One" => "Tell us what item you need using our form",
      "Two" => "We email you the location of the item",
      "Three" => "We coordinate item exchange or delivery"
    }

    # One (Form) http://img.allvoices.com/thumbs/event/609/480/59012320-pen-paper.jpg
    # Two (Mail) http://img.allw.mn/www/thumbs/104/930.jpgs
    # Three (Gift) http://cdn.smugmug.com/img/help/personal-delivery/personal-delivery-box-1.jpg
  end
end
