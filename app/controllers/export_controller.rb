require 'exporter'

class ExportController < ApplicationController
  before_filter :set_book

  def html
    @html = Exporter::Html.new
    @book.export @html

    render :layout => false
  end

  def text
    text = Exporter::Text.new
    @book.export text

    render_export text
  end

  def textile
    textile = Exporter::Textile.new
    @book.export textile

    render_export textile
  end

  def yaml
    yaml = Exporter::Yaml.new
    @book.export yaml

    render_export yaml
  end

  private

  def render_export(txt)
    headers['Content-Type'] = 'text/plain'
    render :text => txt.to_s
  end

  def set_book
    @book = Book.find params[:id]
  end

end

