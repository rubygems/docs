class ChapterController < ApplicationController

  before_filter :login_required

  def new
    @book = Book.find params[:book_id]
    @chapter = @book.chapters.build params[:chapter]

    @chapter.parent = @book.chapters.find params[:chapter_id] if
      params.key? :chapter_id

    if request.post? and @chapter.save then
      flash['notice'] = 'Chapter was successfully created.'
      redirect_to_chapter @chapter
    end
  end

  def delete
    if params[:id] then
      @chapter = Chapter.find params[:id]
      @book    = @chapter.book
      @chapter.destroy
    elsif params[:marked] then
      matches = Chapter.find params[:marked].keys
      [matches].flatten.compact.uniq.each do |chapter|
        @book = @chapter.book
        chapter.destroy
      end
    end

    redirect_to_book @book
  end

  def edit
    @chapter = Chapter.find params[:id]
    @book    = @chapter.book
    @chapter.attributes = params[:chapter]

    if request.post? and @chapter.save then
      flash['notice'] = 'Chapter was successfully updated.'
      redirect_to_chapter @chapter
    end
  end

  # Move up, down, to top and to bottom
  { :up => :move_higher,
    :down => :move_lower,
    :top => :move_to_top,
    :bottom => :move_to_bottom}.each do |action, list_method|
    define_method(action) do
      if params[:id] then
        @chapter = Chapter.find params[:id]
        @chapter.send list_method
      end
      redirect_to_chapter @chapter
    end
  end

end

