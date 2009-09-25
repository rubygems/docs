class TextileExporter

  def initialize
    @body = ""
  end

  def add_text(attr_name, value)
    case attr_name
    when :title
      @body << "#{headline} #{value}\n\n"
    else
      @body << "#{value}\n\n"
    end
  end

  def add_textile(attr_name, value)
    add_text attr_name, value
  end

  def enter_section(section_name)
    @section = section_name
    yield if block_given?
  end

  def to_s
    @body.to_s
  end

  private

  def headline
    case @section
    when :book then    'h1.'
    when :chapter then 'h2.'
    else               'h3.'
    end
  end

end

