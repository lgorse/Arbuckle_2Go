# == Schema Information
#
# Table name: ArbuckleOrderList
#
#  orderID    :integer          not null, primary key
#  UserID     :integer          not null
#  Order Date :date             not null
#  DUE DATE   :date             not null
#  Day        :string(36)       not null
#  Time       :time             not null
#  Blocked    :boolean          default(FALSE), not null
#  Filled     :boolean          default(FALSE), not null
#

class Order < ActiveRecord::Base
	self.table_name = "ArbuckleOrderList"
	alias_attribute :userID, :UserID
	alias_attribute :date, "Order Date"
	alias_attribute :day, :Day
	alias_attribute :due, "DUE DATE"
	alias_attribute :time, :Time
	alias_attribute :blocked, :Blocked
	alias_attribute :filled, :Filled

	attr_accessible :userID, :date, :day, :due, :time, :blocked, :filled
	
  
end
