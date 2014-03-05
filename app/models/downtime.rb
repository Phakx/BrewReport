class Downtime < ActiveRecord::Base
  def difference
    #Downtime Length in Minutes
    (self.end - self.start) / 60
  end
end
