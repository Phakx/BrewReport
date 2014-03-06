class CreateCustomerConfigurations < ActiveRecord::Migration
  def change
    create_table :customer_configurations do |t|
      t.belongs_to :customer
      t.integer :dailySlaStart
      t.integer :dailySlaEnd
      t.text :weeklySlaDays
      t.text :excludedDays

      t.timestamps
    end
  end
end
