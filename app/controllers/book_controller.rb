class BookController < ApplicationController

  before_filter :login_required

  def new
    @book = Book.new params[:book]
    if request.post? and @book.save then
      flash['notice'] = 'Book was successfully created.'
      redirect_to_book @book
    end
  end

  def delete
    if params[:id] then
      Book.find(params[:id]).destroy
    elsif params[:marked] then
      matches = Book.find params[:marked].keys
      [matches].flatten.compact.uniq.each { |book| book.destroy }
    end

    redirect_to shelf_path
  end

  def edit
    @book = Book.find params[:id]
    @book.attributes = params[:book]

    if request.post? and @book.save then
      flash['notice'] = 'Book was successfully updated.'
      redirect_to_book @book
    end
  end

end

