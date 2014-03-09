class CreateSlaPerDays < ActiveRecord::Migration
  def change
    create_table :sla_per_days do |t|
      t.integer :day
      t.belongs_to :SlaPerMonth

      t.timestamps
    end
  end
end
