require 'date/format'
require 'time'

class SyndicateController < ApplicationController
  layout nil

  before_filter :serve_xml

  def atom
    @posts = PageRevision.recent_changes(20, calculate_offset)
  end

  def changes
    atom
    render_action "atom"
  end

  def rss
    @posts = PageRevision.recent_changes(20, calculate_offset)
  end

  private

  def serve_xml
    @headers['Content-Type'] = 'application/xml'
  end

end

