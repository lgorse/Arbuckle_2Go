class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :UserName
      t.string :first_name
      t.string :last_name
      t.string :e_mail
      t.integer :just_sent

      t.timestamps
    end
  end
end
