class ChangeOrderColumn < ActiveRecord::Migration
  def change
  	change_column :orders, :time, :datetime, :default => Time.current
  end
end
