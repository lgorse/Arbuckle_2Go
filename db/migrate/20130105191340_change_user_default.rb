class ChangeUserDefault < ActiveRecord::Migration
  def change
  	change_column :users, :first_name, :string, :default => ''
  	change_column :users, :last_name, :string, :default => ''
  	change_column :users, :e_mail,:string, :default => ''
  	change_column :users, :just_sent,:integer, :default => 0
  	end
end
