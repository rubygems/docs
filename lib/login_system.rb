module LoginSystem
  # overwrite if you want to have special behavior in case the user is not
  # authorized to access the current operation.
  #
  # the default action is to redirect to the login screen
  #
  # example use:
  #
  # a popup window might just close itself for instance

  def access_denied
    redirect_to login_path
  end

  # overwrite this if you want to restrict access to only a few actions or if
  # you want to check if the user has the correct rights
  #
  # example:
  #
  #  #only allow nonbobs
  #  def authorize?(user)
  #    user.login != 'bob'
  #  end

  def authorize?(user)
    true
  end

  # login_required filter. add
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management.
  #
  # for finer access control you can overwrite
  #
  #   def authorize?(user)

  def login_required
    return true if session[:author] and authorize?(session[:author])

    # store current location so that we can
    # come back after the user logged in
    store_location

    # call overwriteable reaction to unauthorized access
    access_denied

    false
  end

  # move to the last store_location call or to the passed default one

  def redirect_back_or_default(default)
    if session[:return_to].nil? then
      redirect_to default
    else
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end

  # store current uri in  the session.
  #
  # we can return to this location by calling return_location

  def store_location
    session[:return_to] = request.request_uri
  end

end

