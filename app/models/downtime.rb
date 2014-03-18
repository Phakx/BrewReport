class Downtime < ActiveRecord::Base
  belongs_to :sla_per_day
  def difference
    #Downtime Length in Minutes
    (self.end - self.start) / 60
  end

  def self.check_if_downtime_exists(start_datetime, end_datetime)
    begin
      self.where('start = ? AND end = ?', start_datetime, end_datetime).take!
    rescue
      return nil
    end
  end
end
