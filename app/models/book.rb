require 'html_engine'

class Book < ActiveRecord::Base

  has_many :children, :conditions => 'parent_id IS NULL',
           :dependent => :destroy,
           :order => 'position', :class_name => 'Chapter',
           :foreign_key => 'book_id'

  has_many :chapters, :foreign_key => 'book_id'

  named_scope :published, lambda {
    { :conditions => ['published = ?', true] }
  }

  def body_html
    HtmlEngine.transform body
  end

  def chapter(num)
    Chapter.find_by_book_id_and_parent_id_and_position self.id, NULL, num.to_i
  end

  def export(exporter)
    exporter.enter_section :book do
      exporter.add_text :title, self.title
      exporter.add_textile :body, self.body
      for chapter in children
        chapter.export exporter
      end
    end
  end

  def intro_html
    HtmlEngine.transform intro
  end

end

