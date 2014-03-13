module SlaPerMonthsHelper

  def self.find_or_create_sla_per_day(day, month, year)
    sla_per_months = SlaPerMonth.retrieve_by_month_and_year(month, year)
    sla_per_month = sla_per_months[0]
    if sla_per_month[0].exists?
      sla_per_days = SlaPerDay.find_by_SlaPerMonth_id(sla_per_month.id)
      unless sla_per_days.any? { |sla| sla.day = day }
        sla_per_day =SlaPerDay.new
        sla_per_day.day = day
        sla_per_day.sla_per_month = sla_per_month
        sla_per_day.save
        return sla_per_day
      end
    else
      sla_per_month = SlaPerMonth.new
      sla_per_month.month= month
      sla_per_month.year = year
      if sla_per_month.save
        return sla_per_month
      else
        raise("massive failure")
      end
    end
  end
end
