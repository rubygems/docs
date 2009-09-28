module ApplicationHelper

  def site_name
    'RubyGems Manuals'
  end

  def author_welcomeline
    "You are logged in as #{session[:author].name}. #{link_to 'logout', :controller => 'account', :action => 'logout'}." if author?
  end

  def book_title_or_tagline(string)
    return string unless @book
    link_to @book.title, book_path(@book)
  end

  def find_next_item(current)
    current.lower_item
  end

  def find_prev_item(current)
    current.higher_item
  end

  def list_link(direction, obj)
    return if %w{top bottom}.include?(direction) #temp disable

    case direction
    when 'up',   'top'    then return if obj.first?
    when 'down', 'bottom' then return if obj.last?
    end

    link_to(direction, :controller => obj.class.name.underscore,
            :action => direction, :id => obj.id)
  end

  def link_to_image(image, options)
    link_to image_tag(image), options
  end

  def link_to_page(text, page)
    link_to text, chapter_path(page.chapter, :anchor => "page#{page.id}")
  end

  def render_errors(obj)
    return '' unless obj

    if controller.request.post? then
      tag = []

      unless obj.valid? then
        tag << %{<ul class="objerrors">}

        obj.errors.each_full do |message|
          tag << "<li>#{message}</li>"
        end

        tag << '</ul>'
      end

      tag.join
    end
  end

  def render_flash
    tag = []

    flash.each do |key, value|
      tag << "<div id=\"flash_#{key}\">#{value}</div>"
    end

    tag.join "\n"
  end

  def render_navigation(parent, options = {})
    return unless parent.respond_to? :children

    configuration = { :recursive => true, :chapters => true, :pages => true }

    configuration.update(options) if Hash === options

    nav = []

    for item in parent.children
      if configuration[:chapters] then
        nav << "<li>#{link_to item.title, chapter_path(item)}</li>\n"
      end

      # if this is the currently active category add links to pages
      if configuration[:pages] and not item.pages.empty? then
        nav << "<ul>\n"
        item.pages.each do |page|
          nav << '<li>'
          nav << link_to_page(page.title, page)
          nav << "</li>\n"
        end
        nav << "</ul>\n"
      end

      # add sub categories
      if configuration[:recursive] and not item.children.empty? then
        nav << "<ol>\n"
        nav << render_navigation(item, options)
        nav << "</ol>\n"
      end
    end

    nav.join
  end

end

