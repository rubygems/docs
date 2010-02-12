require 'html_engine'

class PageRevision < ActiveRecord::Base
  belongs_to :page
  belongs_to :author

  RECENT_CHANGES_SQL = <<-SQL.gsub(/\s+/, ' ')
    SELECT DISTINCT page_revisions.page_id, page_revisions.*
      FROM page_revisions, pages, chapters, books
      WHERE pages.id = page_revisions.page_id AND
            chapters.id = pages.chapter_id AND
            books.id = chapters.book_id AND
            books.published = 't'
    ORDER by page_revisions.id desc LIMIT ? OFFSET ?
  SQL

  def self.new_from_page(page)
    revision = new
    revision.page = page
    revision.title = page.title
    revision.body = page.body
    revision.author = page.author
    revision
  end

  def self.recent_changes(limit, offset = 0)
    find_by_sql [RECENT_CHANGES_SQL, limit, offset]
  end

  def body_html
    HtmlEngine.transform body
  end

  protected

  def before_save
    self.revision = PageRevision.count(:conditions => ['page_id = ?', self.page_id]) + 1
  end

end

