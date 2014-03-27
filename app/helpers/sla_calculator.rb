class SlaCalculator

  def initialize(customer)
    @customer = customer
    @customer_config = CustomerConfiguration.find_by_customer_id(@customer.id)
  end

  def populate_monthly_sla_for(month)
    all_spm_by_customer = SlaPerMonth.retrieve_all_by_customer(@customer)
    sla_per_month = all_spm_by_customer.each do |spm|
      if spm.month == month
        return spm
      else
        raise 'no Data present'
      end
    end
    spds = SlaPerDay.where('sla_per_month_id = ?', sla_per_month.id).to_a
    monthly_downtime_in_minutes = 0
    spds.each do |spd|
      unless !@customer_config.excludedDays.contains(spd) || @customer_config.weeklySlaDays.contains(spd)
        monthly_downtime_in_minutes += get_effective_downtime_for_day(spd)
      end
    end
    monthly_downtime_info = MonthlyDowntimeInfo.new
    monthly_downtime_info.configured_availability = @customer_config.get_availablility_in_minutes
    monthly_downtime_info.downtime_in_minutes = monthly_downtime_in_minutes
    monthly_downtime_info
  end

  def get_effective_downtime_for_day(sla_per_day)
    all_by_day = Downtime.retrieve_all_by_day(sla_per_day)
    daily_sla_start = @customer_config.dailySlaStart
    daily_sla_end = @customer_config.dailySlaEnd
    daily_downtime = 0
    all_by_day.each do |downtime|
      downtime.start = daily_sla_start unless daily_sla_start < downtime.start
      downtime.end = daily_sla_end unless daily_sla_end > downtime.end
      daily_downtime += downtime.difference
    end
    daily_downtime
  end
end