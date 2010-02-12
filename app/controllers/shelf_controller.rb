class ShelfController < ApplicationController

  def about
  end

  def index
    @books = author? ? Book.find(:all) : Book.published
  end

  def recent
    require 'date/format'

    recent = PageRevision.recent_changes 20, calculate_offset

    timeline = Hash.new { |h,k| h[k] = [] }

    recent.each do |item|
      timeline[date_from_time(item.created_at)] << item
    end

    @timeline = timeline.sort_by do |date, items| -date.to_i end
  end

  private

  def date_from_time time
    Time.mktime time.year, time.month, time.day
  end

end

