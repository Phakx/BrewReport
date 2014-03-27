class SlaPerMonth < ActiveRecord::Base
  belongs_to :customer
  has_many :sla_per_days

  def self.retrieve_all_by_customer(customer)
    self.where('customer_id = ?', customer).to_a
  end

  def self.retrieve_by_month_and_year(month, year)
    self.where('month = ? AND year = ?', month, year).take
  end

end
