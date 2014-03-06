class CreateDowntimes < ActiveRecord::Migration
  def change
    create_table :downtimes do |t|
      t.datetime :start
      t.string :downtimeType
      t.datetime :end
      t.string :comment
      t.belongs_to :SlaPerMonth

      t.timestamps
    end
  end
end
