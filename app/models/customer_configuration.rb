class CustomerConfiguration < ActiveRecord::Base
  belongs_to :customer
  def get_availablility_in_seconds
    (self.dailySlaEnd - self.dailySlaStart)
  end
end
