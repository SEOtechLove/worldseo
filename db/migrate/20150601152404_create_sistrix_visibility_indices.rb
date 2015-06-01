class CreateSistrixVisibilityIndices < ActiveRecord::Migration
  def change
    create_table :sistrix_visibility_indices do |t|
      t.string :url
      t.string :channel
      t.string :kw
      t.string :index

      t.timestamps null: false
    end
  end
end
