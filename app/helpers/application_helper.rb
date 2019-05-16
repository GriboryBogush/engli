module ApplicationHelper

  # Format date like: Tuesday 30 Apr 2019
  def date_formatter(date)
    date.strftime('%A %d %b %Y')
  end
end
