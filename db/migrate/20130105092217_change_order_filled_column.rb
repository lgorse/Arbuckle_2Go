class ChangeOrderFilledColumn < ActiveRecord::Migration
  def change
  	change_column :orders, :filled, :integer, :null => false, :default => 0
  end
end
