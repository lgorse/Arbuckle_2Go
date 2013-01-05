class CreateOrderDetail < ActiveRecord::Migration
  def change
  	create_table :order_details do |t|
  		t.integer :orderID
  		t.integer :typeID
  		t.integer :groupID
  		t.integer :itemID
  		t.integer :quantity
  		t.boolean :spicy
  end
  add_index :order_details, :orderID
end
end
