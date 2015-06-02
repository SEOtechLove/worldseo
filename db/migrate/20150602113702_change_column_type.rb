class ChangeColumnType < ActiveRecord::Migration
  def change

  	change_column :sistrix_visibility_indices, :sistrix_index, :decimal
  end
end

