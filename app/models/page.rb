class Page < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :author

  has_many :revisions, :class_name => 'PageRevision', :dependent => :destroy,
           :order => 'id DESC'
  has_one :revision, :class_name => 'PageRevision', :order => 'id DESC'

  acts_as_list :foreign_key => 'parent_id', :order => 'position',
               :scope => 'chapter_id = #{chapter_id}'

	validates_presence_of :chapter_id, :body, :title

  def body_html
    HtmlEngine.transform body
  end

  def changed?
    @new_record || @original_title != title || @original_body != body
  end

  def export(exporter)
    exporter.enter_section :page do
      exporter.add_text :title, title
      exporter.add_textile :body, body
    end
  end

  protected

  def after_find
    @original_title, @original_body = title, body
  end

end

