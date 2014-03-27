class CustomerConfiguration < ActiveRecord::Base
  belongs_to :customer

  def get_availablility_in_minutes
    (self.dailySlaEnd - self.dailySlaStart) / 60
  end
end
