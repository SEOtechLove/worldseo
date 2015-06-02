class CreateSearchmetricsIndices < ActiveRecord::Migration
  def change
    create_table :searchmetrics_indices do |t|
      t.string :url
      t.string :channel
      t.string :calender_week
      t.integer :searchmetrics_index

      t.timestamps null: false
    end
  end
end
