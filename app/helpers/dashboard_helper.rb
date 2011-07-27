module DashboardHelper

  def unallocated_resources(practice, period, columns)
    
    date = Date.today
    case columns
        when 'year'
          date = Date.new(period.to_i, Date.today.month, Date.today.day)
          #@periods << "#{date_from.year}"
          #date_from = (date_from + 1.year).at_beginning_of_year
        when 'month'
          yr_month = period.split("-")
          date = Date.new(yr_month[0].to_i, yr_month[1].to_i, 1)
          #@periods << "#{date_from.year}-#{date_from.month}"
          #date_from = (date_from + 1.month).at_beginning_of_month
        #when 'week'
          #@periods << "#{date_from.year}-#{date_from.to_date.cweek}"
          #date_from = (date_from + 7.day).at_beginning_of_week
        when 'day'
          ymd = period.split("-")
          date = Date.new(ymd[0].to_i, ymd[1].to_i, ymd[2].to_i)
          #@periods << "#{date_from.to_date}"
          #date_from = date_from + 1.day
    end
  unallocated_resources = practice.unallocated_resources(date, columns)
  return unallocated_resources   
  end


end