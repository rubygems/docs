class AuthorObserver < ActiveRecord::Observer

  def after_create(author)
    author.update_attribute 'approved_by_id', author.id if
      author.class.count('approved_by_id IS NOT NULL').zero?
  end

  def after_save(author)
    if CONFIG['email'] and author.freshly_approved? then
      Notifier.deliver_account_approval author
    end
  end

end

