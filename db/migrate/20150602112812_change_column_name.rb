class ChangeColumnName < ActiveRecord::Migration
  def change
  	#rename_column :sistrix_visibility_indices, :index, :sistrix_index
  	change_column :sistrix_visibility_indices, :sistrix_index, :decimal
  end
end
