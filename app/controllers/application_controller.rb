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
end
