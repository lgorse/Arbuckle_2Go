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
require "net/http"
require "uri"
require "chronic"

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
		time_data = Order.time_stamp
		order.userID = userID
		order.date = Date.current
		order.day = Date.current.strftime('%a')
		order.due = Order.set_due_date(time_data)
		order.time = Time.current
		order.blocked = false
		order.filled = PENDING
		order.save
		return order
	end

	def self.set_session_order(user, time_data)
		if time_data.fetch("validtime") == ORDER_LOCKOUT
			order_array = Order.where("`UserID` =?  AND `Filled` = ? AND `Due Date` = ?", user.userID, SENT, Date.current)
		else 
			order_array = Order.where("`UserID` =?  AND (`Filled` = ? OR `Filled` = ?)", user.userID, PENDING, CONFIRMED)
		end
		
		if order_array.size > 1
			order_array.destroy_all
			set_session_order(user, time_data)
		end

		order_array.blank? ? @order = Order.blank_order(user.userID) : @order = order_array.first	
	end

	def update_order(blocked_value, filled_value)
		time_data = Order.time_stamp
		self.update_attribute(:date, Date.current)
		self.update_attribute(:day, Date.current.strftime('%a'))	
		self.update_attribute(:due, Order.set_due_date(time_data))
		self.update_attribute(:time, Time.current)
		self.update_attribute(:blocked, blocked_value)
		self.update_attribute(:filled, filled_value)
		return time_data
	end

	def total
		@total = self.order_details.inject(0) do |result, detail|
			detail.item.blank? || detail.item.price.blank? ? price = 0 : price = detail.item.price
			result + detail.quantity * price
		end
		SPECIALS_LIST.each do |groupNum|
			@total += Group.find(groupNum).price if self.order_details.any?{|detail| detail.groupID == groupNum}
		end
		@total += Type.find(CHEF_SPECIAL).price if self.order_details.any?{|detail| detail.typeID == CHEF_SPECIAL}
		return @total
	end

	#time stamp

	def self.time_stamp
		uri = URI.parse("http://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafeTimeStampPrint.php")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		http.finish if http.started?
		time_data = JSON.parse(response.body)
	end

	def self.set_due_date(time_data)
		valid_time = time_data.fetch("validtime")
		case valid_time
		when ORDER_TODAY then
			due = Date.current
		when ORDER_NEXT_DAY then
			due = Chronic.parse(time_data.fetch("nextDay", :context => :future)).to_date
		else
			due = Chronic.parse(time_data.fetch("nextDay", :context => :future)).to_date
		end

	end

	#combo order filling

	def filled?(combo)
		return false if combo.typeID == 1
		if combo.class == Group
			quant_by_combo(combo) == Group.order_max(combo.groupID)
		elsif combo.class == Type
			combo.groups.where(:groupID =>[SUSHI_CHEF_SPECIAL_GROUPS]).all? {|group| self.filled?(group)}
		else
			nil
		end
	end

	def quant_by_combo(combo)
		self.order_details.select{|detail| detail.groupID == combo.groupID && detail.itemID != 0}.collect{|detail| detail.quantity}.sum
	end

	def incomplete_combos?
		Group.where(:groupID => [COMBO_SPECIALS_LIST]).any? do |group|
			if self.quant_by_combo(group) > 0 && (!self.filled?(group)||!self.filled?(group.type))
				return true, group
			end
		end
	end

	#combo order canceling

	def cancel_chef_special(combo)
		self.order_details.where(:typeID => combo.typeID).destroy_all
	end

	def cancel_special(combo)
		self.order_details.where(:groupID => combo.groupID).destroy_all
		
	end

	def add_combo_hacks
		Type.find_each do |type|
			if self.order_details.find_by_typeID(type.typeID)
				case type.typeID
				when CHEF_SPECIAL then
					Order.create_chef_special_hack(self.orderID, type.typeID) if !self.order_details.find_by_typeID_and_itemID(type.typeID, 0)
				when SPECIAL then
					if self.order_details.find_by_groupID(SASHIMI)
						Order.create_special_hack(self.orderID, type.typeID, SASHIMI) if !self.order_details.find_by_groupID_and_itemID(SASHIMI, 0)
					end
				else 
					nil
				end
			end
		end

	end

	def self.create_chef_special_hack(orderID, typeID)
		OrderDetail.create!(:orderID => orderID, :typeID => typeID,	
			:groupID => USELESS_SPECIAL, :itemID => 0, :quantity => 1, 
			:spicy => false)
	end

	def self.create_special_hack(orderID, typeID, groupID)
		OrderDetail.create!(:orderID => orderID, :typeID => typeID,
			:groupID => groupID, :itemID => 0, :quantity => 1,
			:spicy => false)
	end


end
