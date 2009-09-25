class ShelfController < ApplicationController

  def about
  end

  def index
    @books = author? ? Book.find(:all) : Book.published
  end

  def recent
    require 'date/format'

    @recent = PageRevision.recent_changes(20, calculate_offset)

    timeline = @recent.inject(Hash.new) do |hash, item|
      date = date_from_time(item.created_at)
      hash[date] ||= []
      hash[date] << item
      hash
    end

    @timeline = sort_desc(timeline)
  end

  private

  def date_from_time(time)
    Date.new(time.year, time.month, time.day)
  end

  def sort_desc(list)
    list.sort { |a,b| -(a <=> b) }
  end

end

