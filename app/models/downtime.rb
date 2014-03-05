class Downtime < ActiveRecord::Base
  def difference
    (self.end - self.start) / 60
  end
end
