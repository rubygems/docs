class PageController < ApplicationController

  before_filter :login_required

  def delete
    if params[:id] then
      @page    = Page.find params[:id]
      @chapter = @page.chapter
      @page.destroy
    elsif params[:marked] then
      matches = Page.find params[:marked].keys
      [matches].flatten.compact.uniq.each { |page| page.destroy }
      @chapter  = matches.first.chapter
    end

    redirect_to_chapter @chapter
  end

  def diff
    @page    = Page.find params[:id]
    @chapter = @page.chapter
    @book    = @page.chapter.book

    @left    = params[:rev] ? @page.revision(params[:rev]) : @page.latest
    @right   = params[:rev] ? @page.revision(params[:to]) : @page.latest
  end

  def edit
    @page = Page.find params[:id]
    @chapter = @page.chapter
    @book = @chapter.book
    @page.attributes = params[:page]
    @page.author = session[:author]

    if request.post? and @page.save then
      flash['notice'] = 'Page was successfully created.'
      redirect_to_chapter @chapter
    end
  end

  def history
    @page    = Page.find params[:id]
    @chapter = @page.chapter
    @book    = @page.chapter.book
  end

  def new
    @chapter = Chapter.find params[:id]
    @book = @chapter.book

    @page = Page.new params[:page]
    @page.author = session[:author]
    @page.chapter = @chapter
    @page.revision = @revision

    if request.post? and @page.save then
      flash['notice'] = 'Page was successfully created.'
      redirect_to_chapter @chapter
    end
  end

  def show
    @page    = Page.find params[:id]
    @chapter = @page.chapter
    @book    = @page.chapter.book

    @text    = params[:rev] ? @page.revision(params[:rev]) : @page.latest
  end

  # Move up, down, to top and to bottom
  { :up => :move_higher,
    :down => :move_lower,
    :top => :move_to_top,
    :bottom => :move_to_bottom}.each do |action, list_method|
    define_method(action) do
      if params[:id]
        @page    = Page.find params[:id]
        @chapter = @page.chapter
        @page.send list_method
        redirect_to_chapter @chapter
      else
        redirect_to_shelf
      end
    end
  end

end

