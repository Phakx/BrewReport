class SlaPerDay < ActiveRecord::Base
  belongs_to :sla_per_month
  has_many :downtimes
end
