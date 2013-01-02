class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :groupID
      t.string :itemName
      t.decimal :Price
      t.boolean :ComboSubset
      t.string :Detail
      t.string :Spicy

      t.timestamps
    end
    add_index :items, :groupID
  end
end
