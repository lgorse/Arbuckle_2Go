class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :orderID, :null => false
      t.integer :typeID, :null => false
      t.integer :groupID, :null => false
      t.integer :itemID, :null => false
      t.integer :quantity, :null => false
      t.boolean :spicy, :null => false
      t.timestamps
    end
    add_index :order_details, [:orderID, :groupID]
  end
end
