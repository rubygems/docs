require 'html_engine'

class MarkupController < ApplicationController

  layout nil

  def preview
    case request.method
    when :get then
      render :text => "This is a markup transformation service. Please talk to me with HTTP POST"
    when :post then
      render :text => HtmlEngine.transform(params['text'])
    end
  end

  def popup
  end

end

