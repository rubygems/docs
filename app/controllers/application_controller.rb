class ApplicationController < ActionController::Base
  include LoginSystem

  helper :all
  protect_from_forgery
  #filter_parameter_logging :password

  protected

  helper_method :author?

  def author?
    session[:author]
  end

  def calculate_offset
    20 * params[:page].to_i
  end

  def choose_layout
    @book ? 'with-book' : 'without-book'
  end

  def redirect_back(default = { :controller => "shelf" })
    if request.env['HTTP_REFERER'] then
      redirect_to_url request.env['HTTP_REFERER']
    else
      redirect_to default
    end
  end

  def redirect_to_book(book)
    return redirect_to shelf_path if book.nil?
    redirect_to book_path(book)
  end

  def redirect_to_chapter(chapter)
    return redirect_to_book(@book) if chapter.nil?
    redirect_to chapter_path(chapter)
  end

end

