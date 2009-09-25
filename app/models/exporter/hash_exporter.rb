class HashExporter
  attr_accessor :root

  def initialize
    @current = @root = {}
  end

  def add_text(attr_name, value)
    @current[attr_name.to_s] = value
  end

  def add_textile(attr_name, value)
    add_text attr_name, value
  end

  def enter_section(section_name)
    # store parent
    parent = @current
    # create the new hash
    @current = {}
    yield if block_given?

    # eventually create the array for this subsection and add the new section
    (parent[section_name.to_s] ||= []) << @current

    @current = parent
  end

  def to_s
    root.inspect
  end

end

