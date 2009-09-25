class ReadController < ApplicationController

  def index
    book
    render :action => 'book'
  end

  def book
    @book = Book.find params[:id]
  end

  def chapter
    @chapter = Chapter.find params[:id]
    @book    = @chapter.book
    @pages   = @chapter.pages
  end

  def error
    @title ||= 'General error'
    render :action => 'error'
  end

  protected

  def rescue_action_in_public(exception)
    @title = 'Record not found' if ActiveRecord::RecordNotFound === exception

    error
  end

end

