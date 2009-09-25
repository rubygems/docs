class MarkupController < ApplicationController

  layout nil

  def preview
    case request.method
    when :get then
      render_text "This is a markup transformation service. Please talk to me with HTTP POST"
    when :post then
      render_text HtmlEngine.transform(request.raw_post)
    end
  end

  def popup
  end

end

