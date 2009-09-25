require 'text/format'

class Exporter::Text

  attr_accessor :text

  def initialize
    @text = ""
    @depth = 0
  end

  def add_text(attr_name, value)
    case attr_name
    when :title
      text << "=" * @depth
      text << " #{value}\n\n"
    when :body
      text << "#{value}\n"
    end
  end

  def add_textile(attr_name, value)
    formatted = value.split(/[\n\r]{3,}/).map do |paragraph|
      text = Text::Format.new(:columns => 80, :first_indent => 1,
                              :body_indent => 1, :text => paragraph,
                              :nobreak_regex => /\<pre\>.*<\/pre\>/)
      text.format
    end.join("\n")

    add_text attr_name, formatted
  end

  def enter_section(section_name)
    @depth += 1
    yield if block_given?
    @depth -= 1
  end

  def to_s
    @text
  end

end

