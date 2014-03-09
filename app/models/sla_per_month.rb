class SlaPerMonth < ActiveRecord::Base
  belongs_to :customer
  has_many :sla_per_days
end
