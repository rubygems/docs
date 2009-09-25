class Exporter::Yaml < Exporter::Hash

  def to_s
    root.to_yaml
  end

end

