class SlaPerMonth < ActiveRecord::Base
  belongs_to :customer
  has_many :sla_per_days

  def self.retrieve_by_month_and_year(month, year)
    self.where('month = ? AND year = ?', month, year)
  end
end
