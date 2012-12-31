class AddDefaultValueToUser < ActiveRecord::Migration
  def change
  	change_column :users, :e_mail, :string, :default => ""
  	change_column :users, :first_name, :string, :default => ""
  	change_column :users, :last_name, :string, :default => ""
  end
end
