class UnplannedDowntimeCalculator
  TIME_CONVERSION = '%H%M'

  def initialize(customer)
    @customer = customer
    @customer_config = CustomerConfiguration.find_by_customer_id(@customer.id)
  end

  def populate_monthly_sla_for(month)
    spds = month.sla_per_days
    monthly_downtime_in_seconds = 0
    special_exclude_days = []
    int_array = []
    unless @customer_config.weeklySlaDays.nil?
      int_array = @customer_config.weeklySlaDays.split(',').collect { |i| i.to_i }
    end
    unless @customer_config.excludedDays.nil?
      special_exclude_days = @customer_config.excludedDays.split(',').collect { |date_string| DateTime.parse(date_string) }
    end

    day_is_in_conf_weekly_and_not_excluded =lambda { |day_to_check|
      int_array.include?(day_to_check.wday) && !special_exclude_days.include?(day_to_check)
    }
    spds.each do |spd|

      t = DateTime.new(month.year.to_i, month.month.to_i, spd.day.to_i)
      if day_is_in_conf_weekly_and_not_excluded.call(t)
        monthly_downtime_in_seconds += get_effective_downtime_for_day(spd)
      end

    end
    monthly_downtime_info = MonthlyDowntimeInfo.new
    available_days_in_month = lambda {
      date_new = Date.new(month.year.to_i, month.month.to_i)
      days_in_month = (date_new.beginning_of_month..date_new.end_of_month).count { |day| day_is_in_conf_weekly_and_not_excluded.call(day) }
      Rails.logger.debug "Available days in  month: #{days_in_month}"
      days_in_month
    }
    seconds = @customer_config.get_availablility_in_seconds * available_days_in_month.call
    monthly_downtime_info.configured_availability = seconds

    monthly_downtime_info.downtime_in_seconds = monthly_downtime_in_seconds
    monthly_downtime_info
  end

  def get_effective_downtime_for_day(sla_per_day)
    Rails.logger.debug "#{sla_per_day}"
    all_downtimes_by_day = Downtime.retrieve_all_by_day(sla_per_day)
    daily_downtime = 0
    Time.zone = 'Berlin'
    all_downtimes_by_day.each do |downtime|

      adowntime = check_if_downtime_is_in_range_and_set_borders(downtime)
      unless adowntime.nil?
        difference = adowntime.difference
        Rails.logger.debug "Difference is: #{difference}"
        daily_downtime += difference
      end
    end
    daily_downtime
  end

  def check_if_downtime_is_in_range_and_set_borders(downtime)
    daily_sla_start = @customer_config.dailySlaStart
    daily_sla_end = @customer_config.dailySlaEnd
    downtime_starts_after_daily_end = downtime.start.strftime(TIME_CONVERSION) > daily_sla_end.strftime(TIME_CONVERSION)
    downtime_ends_before_daily_start = downtime.end.strftime(TIME_CONVERSION) < daily_sla_start.strftime(TIME_CONVERSION)
    type_does_not_include_critical = !downtime.downtime_type.include?('CRITICAL')
    unless downtime_starts_after_daily_end || downtime_ends_before_daily_start || type_does_not_include_critical

      Rails.logger.debug "Downtime start is : #{downtime.start.strftime(TIME_CONVERSION)}, Daily SLA start is: #{daily_sla_start.strftime(TIME_CONVERSION)}, Setting start to boundary if necessary"
      sla_start_is_before_downtime_start = daily_sla_start.strftime(TIME_CONVERSION) < downtime.start.strftime(TIME_CONVERSION)
      unless sla_start_is_before_downtime_start
        downtime.start = downtime.start.change({:hour => daily_sla_start.hour, :min => daily_sla_start.min})
      end

      Rails.logger.debug "Downtime end is : #{downtime.end.strftime(TIME_CONVERSION)}, Daily SLA end is: #{daily_sla_end.strftime(TIME_CONVERSION)}, Setting end to boundary if necessary"
      sla_end_is_after_downtime_end = daily_sla_end.strftime(TIME_CONVERSION) > downtime.end.strftime(TIME_CONVERSION)
      unless sla_end_is_after_downtime_end
        downtime.end = downtime.end.change({:hour => daily_sla_end.hour, :min => daily_sla_end.min})
      end
      Rails.logger.debug "Returning: #{downtime}"
      return downtime
    end
    nil
  end

  def get_all_critical_downtimes_for(month)
    critical_downtimes = []
    month.sla_per_days.each { |sla_per_day|
      all_downtimes_by_day = Downtime.retrieve_all_by_day(sla_per_day)
      all_downtimes_by_day.each { |downtime|
        critical_downtimes.push(check_if_downtime_is_in_range_and_set_borders(downtime))
      }
    }
    critical_downtimes.compact!
  end

end