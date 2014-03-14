class CreateSlaPerDays < ActiveRecord::Migration
  def change
    create_table :sla_per_days do |t|
      t.integer :day
      t.belongs_to :sla_per_month

      t.timestamps
    end
  end
end
