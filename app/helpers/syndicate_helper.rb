module SyndicateHelper

  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def post_title(post)
    "#{post.author.name}: #{post.title}"
  end

  def post_link(post)
    url_for(:controller => 'read', :action => 'chapter',
            :id => post.page.chapter.id, :anchor => "page#{post.page.id}",
            :only_path => false)
  end

end
