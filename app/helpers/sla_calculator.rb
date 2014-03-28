class SlaCalculator
  TIME_CONVERSION = '%H%M'

  def initialize(customer)
    @customer = customer
    @customer_config = CustomerConfiguration.find_by_customer_id(@customer.id)
  end

  def populate_monthly_sla_for(month)
    all_spm_by_customer = SlaPerMonth.retrieve_all_by_customer(@customer)
    all_spm_by_customer.each do |spm|
      if spm == month
        @current_sla_per_month = spm
      else
        raise 'no Data present'
      end
    end
    spds = SlaPerDay.where('sla_per_month_id = ?', @current_sla_per_month.id).to_a
    monthly_downtime_in_minutes = 0
    spds.each do |spd|

      weekly_sla_days = @customer_config.weeklySlaDays.split(',')
      int_array = weekly_sla_days.collect { |i| i.to_i }

      t = DateTime.new(@current_sla_per_month.year, @current_sla_per_month.month, spd.day)
      if int_array.include?(t.wday)
        monthly_downtime_in_minutes += get_effective_downtime_for_day(spd)
      end

    end
    monthly_downtime_info = MonthlyDowntimeInfo.new
    minutes = @customer_config.get_availablility_in_minutes * Time.days_in_month(@current_sla_per_month.month.to_i, @current_sla_per_month.year.to_i)
    monthly_downtime_info.configured_availability = minutes

    monthly_downtime_info.downtime_in_minutes = monthly_downtime_in_minutes
    monthly_downtime_info
  end

  def get_effective_downtime_for_day(sla_per_day)
    all_by_day = Downtime.retrieve_all_by_day(sla_per_day)
    daily_sla_start = @customer_config.dailySlaStart
    daily_sla_end = @customer_config.dailySlaEnd
    daily_downtime = 0
    Time.zone = 'Berlin'
    all_by_day.each do |downtime|

      downtime_starts_after_daily_end = downtime.start.strftime(TIME_CONVERSION) > daily_sla_end.strftime(TIME_CONVERSION)
      downtime_ends_before_daily_start = downtime.end.strftime(TIME_CONVERSION) < daily_sla_start.strftime(TIME_CONVERSION)
      type_does_not_include_critical = !downtime.downtime_type.include?('CRITICAL')
      unless downtime_starts_after_daily_end || downtime_ends_before_daily_start || type_does_not_include_critical

        Rails.logger.debug "Downtime start is : #{downtime.start.strftime(TIME_CONVERSION)}, Daily SLA start is: #{daily_sla_start.strftime(TIME_CONVERSION)}, Setting start to boundary if necessary"
        sla_start_is_before_downtime_start = daily_sla_start.strftime(TIME_CONVERSION) < downtime.start.strftime(TIME_CONVERSION)
        unless sla_start_is_before_downtime_start
          downtime.start = downtime.start.change({:hour => daily_sla_start.hour, :minute => daily_sla_start.minute})
        end

        Rails.logger.debug "Downtime end is : #{downtime.end.strftime(TIME_CONVERSION)}, Daily SLA end is: #{daily_sla_end.strftime(TIME_CONVERSION)}, Setting end to boundary if necessary"
        sla_end_is_after_downtime_end = daily_sla_end.strftime(TIME_CONVERSION) > downtime.end.strftime(TIME_CONVERSION)
        unless sla_end_is_after_downtime_end
          downtime.end = downtime.end.change({:hour => daily_sla_end.hour, :minute => daily_sla_end.minute})
        end

        difference = downtime.difference
        Rails.logger.debug "Difference is: #{difference}"
        daily_downtime += difference
      end
    end
    daily_downtime
  end
end