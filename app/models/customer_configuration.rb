class CustomerConfiguration < ActiveRecord::Base
  belongs_to :customer
  validates :customer_id, presence: true
  def get_availablility_in_seconds
    (self.dailySlaEnd - self.dailySlaStart)
  end
end
