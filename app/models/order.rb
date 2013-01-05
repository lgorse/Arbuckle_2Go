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
#  Blocked    :boolean          not null
#  Filled     :integer          not null
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

	attr_protected :userID, :date, :day, :due, :time, :blocked, :filled

	has_many :order_details, :foreign_key => :orderID, :dependent => :destroy
	accepts_nested_attributes_for :order_details
  
end
