class CreateCustomerConfigurations < ActiveRecord::Migration
  def change
    create_table :customer_configurations do |t|
      t.belongs_to :customer
      t.time :dailySlaStart
      t.time :dailySlaEnd
      t.text :weeklySlaDays
      t.text :excludedDays

      t.timestamps
    end
  end
end
