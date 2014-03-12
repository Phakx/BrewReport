class Downtime < ActiveRecord::Base
  belongs_to :sla_per_day
  def difference
    #Downtime Length in Minutes
    (self.end - self.start) / 60
  end
end
