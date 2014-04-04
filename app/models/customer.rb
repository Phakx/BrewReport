class Customer < ActiveRecord::Base
  has_many :customer_configurations
  has_many :sla_per_months
  validates :name, presence: true
end
