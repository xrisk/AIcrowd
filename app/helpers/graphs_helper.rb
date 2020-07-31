module GraphsHelper
  def months_array(start_date, end_date)
    months_array = []

    while start_date <= end_date
      months_array << start_date.strftime('%B')
      start_date += 1.month
    end

    months_array
  end
end
