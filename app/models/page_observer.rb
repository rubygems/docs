class PageObserver < ActiveRecord::Observer

  def after_save(page)
    if page.changed? then
      rev = PageRevision.new_from_page page
      rev.save
    end
  end

end

