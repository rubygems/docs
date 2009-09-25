class AccountController < ApplicationController

  def approve
    if params[:id] then
      @author = Author.find params[:id]
      @author.approve session[:author]

      begin
        @author.save
      rescue SocketError
        redirect_to :controller => 'error', :action => 'email_approval_error', :id => params[:id]
        return
      end
    end

    redirect_back_or_default :controller => 'shelf', :action => 'index'
  end

  def delete
    if params[:id] then
      @author = Author.find params[:id]
      @author.destroy if @author
    end

    redirect_back_or_default :controller => 'shelf', :action => 'index'
  end

  def login
    if request.post? then
      author = Author.authenticate params[:login], params[:password]

      if author then
        session[:author] = author

        flash['notice']  = 'Login successful'
        redirect_back_or_default :controller => 'shelf', :action => 'index'

        return
      else
        @message  = 'Login unsuccessful - Maybe your account is not yet approved?'
      end
    end

    @login = params[:login]
  end

  def logout
    session[:author] = nil
  end

  def signup
    @author = Author.new params[:author]

    if request.post? and @author.save then
      flash['notice']  = 'Signup successful'

      session[:author] =
        Author.authenticate @author.login, params[:author][:password]

      if session[:author] then
        redirect_back_or_default :controller => 'shelf', :action => 'index'
      else
        redirect_to :action => 'welcome'
      end
    end
  end

  def welcome
  end

end

