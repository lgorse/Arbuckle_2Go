class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :userID
      t.date :date
      t.date :due
      t.string :day, :default => ""
      t.time :time
      t.boolean :blocked, :default => false
      t.boolean :filled, :default => true

      t.timestamps
    end
    add_index :orders, :UserID
  end
end
