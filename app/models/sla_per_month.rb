class SlaPerMonth < ActiveRecord::Base
  belongs_to :customer
  has_many :downtimes
end
