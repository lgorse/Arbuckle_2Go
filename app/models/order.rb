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

	def self.blank_order(userID)
		order = Order.new
		order.userID = userID
		order.date = Date.current
		order.day = Date.current.strftime('%a')
		order.due = Date.tomorrow
		order.time = Time.current
		order.blocked = false
		order.filled = PENDING
		order.save
		return order
	end

	def self.set_session_order(user)
		order_array = Order.where(:userID => user.userID, :filled => [PENDING,CONFIRMED])

		if order_array.size > 1
			Order.destroy_all(:userID => user.userID, :filled => [PENDING, CONFIRMED])
			set_session_order(user)
		end

		order_array.blank? ? @order = Order.blank_order(user.userID) : @order = order_array.first	
	end

	def update_order(order)
		self.update_attribute(:date, Date.current)
		self.update_attribute(:day, Date.current.strftime('%a'))	
		self.update_attribute(:due, Date.tomorrow)
		self.update_attribute(:time, Time.current)
		self.update_attribute(:blocked, order[:blocked])
		self.update_attribute(:filled, order[:filled])
	end

  
end
