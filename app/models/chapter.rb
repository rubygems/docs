class Chapter < ActiveRecord::Base

  belongs_to   :book

  has_many     :pages, :dependent => :destroy, :order => 'position'

  acts_as_tree :foreign_key => 'parent_id', :order => 'position'

  acts_as_list :column => 'position',
               :scope => '"; raise \'bug\'; "'

  undef_method :scope_condition

  validates_presence_of :book_id, :title

  def chapter(num)
    Chapter.find_by_book_id_and_parent_id_and_position book_id, id, num.to_i
  end

  def chapter_descriptor
    array = []
    current = self

    begin
      array << current.position
      current = current.parent
    end while current

    array.join '.'
  end

  def export(exporter)
    exporter.enter_section :chapter do
      exporter.add_text :title, title

      for page in pages
        page.export exporter
      end

      for chapter in children
        chapter.export exporter
      end
    end
  end

  def next_chapter(consider_children = true)
    return children.first if consider_children and not children.empty?

    return lower_item if lower_item

    parent.next_chapter false
  end

  def page(num)
    Page.find_by_chapter_id_and_position id, num
  end

  def prev_chapter(consider_children = true)
    return children.last if consider_children and not children.empty?

    return higher_item if higher_item

    parent.prev_chapter false
  end

  def scope_condition
    scope = "book_id = #{book_id} AND "
    scope << if parent_id then
               "parent_id = #{parent_id}"
             else
               "parent_id IS NULL"
             end
  end

end

