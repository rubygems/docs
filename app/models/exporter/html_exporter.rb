class HtmlExporter < TextileExporter

  def to_s
    HtmlEngine.transform(super)
  end

end

