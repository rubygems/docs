class ErrorController < ApplicationController

  def access_denied
    @title = "Access Denied"
    @message = "You must be logged in to see this page."
    @return_string = "Login"
    @return_url = login_path
    render_action 'generic'
  end

  def email_approval_error
    @return_string = 'Back to Approvals'
    @return_url = approve_path

    if !session[:author] then
      # since this error page shows the approved author's email address, we
      # better not show it to just anybody
      access_denied
    elsif params[:id] then
      @title = "Email Error"
      @author = Author.find params[:id]
      @message = "The account was successfully appoved but there was an error while sending the notification email to the author. You may wish to notify them directly at <a href=\"mailto:#{@author.email}\">#{@author.email}</a>."
      render_action 'generic'
    else
      noid
    end
  end

  def noid
    @title = 'No ID Specified'
    @message = 'A required ID was missing from the request URL.'
    render_action 'generic'
  end

end

