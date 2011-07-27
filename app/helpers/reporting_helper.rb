require 'date'

# Helper module that offers some basic functionality to support reporting
module ReportingHelper

  def convert_date(period, columns)
    x = period.split('-')
    puts '========'
    puts x
    case columns
      when 'month'
        Date.new(x[0].to_i, x[1].to_i, 1)
      when 'day'
        Date.new(x[0].to_i, x[1].to_i, x[2].to_i)
    end
  end
end
