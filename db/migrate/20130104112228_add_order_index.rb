class AddOrderIndex < ActiveRecord::Migration
  def change
  	add_index :orders, :id
  end
end
