class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :userID, :null => false
      t.date :date, :null => false
      t.date :due, :null => false
      t.string :day, :default => ""
      t.datetime :time, :null => false
      t.boolean :blocked, :null => false, :default => false
      t.boolean :filled, :null => false, :default => false

      t.timestamps
    end
    add_index :orders, :orderID
  end
end
