class YamlExporter < HashExporter

  def to_s
    root.to_yaml
  end

end

