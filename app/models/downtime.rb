class Downtime < ActiveRecord::Base
  belongs_to :sla_per_day

  def difference
    #Downtime Length in Minutes
    Rails.logger.debug "Starttime: #{self.start}, Endtime: #{self.end}, Comment was: #{self.comment}"
    (self.end - self.start) / 60
  end

  def self.retrieve_all_by_day(sla_per_day_id)
    self.where('sla_per_day_id = ?', sla_per_day_id).to_a
  end

  def self.check_if_downtime_exists(start_datetime, end_datetime)
    begin
      self.where('start = ? AND end = ?', start_datetime, end_datetime).take!
    rescue
      return nil
    end
  end
end
