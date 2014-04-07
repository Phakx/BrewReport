class MonthlyDowntimeInfo < Struct.new(:configured_availability, :downtime_in_seconds)
  def get_availability_in_percent
    (1 - downtime_in_seconds / configured_availability) * 100
  end
end