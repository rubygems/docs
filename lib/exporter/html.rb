require 'html_engine'

class Exporter::Html < Exporter::Textile

  def to_s
    HtmlEngine.transform super
  end

end

