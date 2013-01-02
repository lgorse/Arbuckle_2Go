class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :typeName
      t.decimal :Price

      t.timestamps
    end
  end
end
