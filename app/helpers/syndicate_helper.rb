module SyndicateHelper

  def server_url_for(options = {})
    options = options.megre :only_path => false

    url_for options
  end

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def post_title(post)
    "#{post.author.name}: #{post.title}"
  end

  def post_link(post)
    server_url_for(:controller => 'read', :action => 'chapter',
                   :id => post.page.chapter.id,
                   :anchor => "page#{post.page.id}")
  end

end
