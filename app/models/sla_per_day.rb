class SlaPerDay < ActiveRecord::Base
  belongs_to :sla_per_month
  has_many :downtimes

  def self.retrieve_all_by_sla_per_month(sla_per_month_id)
    self.where('sla_per_month_id = ?', sla_per_month_id).to_a
  end
end
