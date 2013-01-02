class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :typeID
      t.string :groupName
      t.decimal :Price
      t.string :Detail

      t.timestamps
    end
    add_index :groups, :typeID
  end
end
