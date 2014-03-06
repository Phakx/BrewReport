class CreateSlaPerMonths < ActiveRecord::Migration
  def change
    create_table :sla_per_months do |t|
      t.string :month
      t.integer :year
      t.belongs_to :customer
      t.timestamps
    end
  end
end
