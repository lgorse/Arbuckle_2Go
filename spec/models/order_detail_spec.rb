# == Schema Information
#
# Table name: ArbuckleOrderDetails
#
#  DetailID :integer          not null, primary key
#  OrderID  :integer          not null
#  typeID   :integer          not null
#  groupID  :integer          not null
#  itemID   :integer          not null
#  Quantity :integer          not null
#  Spicy    :boolean          not null
#

require 'spec_helper'

describe OrderDetail do


	describe "POST 'create'" do
		
		describe "instance" do

			
			it "should create a new instance given a valid attribute" do
				@detail =OrderDetail.new(:quantity => 2, :spicy => false)
				@detail.orderID = 1
				@detail.typeID = 1
				@detail.groupID = 3
				@detail.itemID = 30
				@detail.save!
			end

			it "should create from the user" do
				@order = Order.new
				@order.userID = 1
				@order.date = Date.current
				@order.day = Date.current.strftime('%a')
				@order.due = Date.tomorrow
				@order.time = Time.current
				@order.blocked = false
				@order.filled = false
				@order.save

				@detail = @order.order_details.new(:quantity => 2, :spicy => false)
				@detail.orderID = @order.orderID
				@detail.typeID = 1
				@detail.groupID = 3
				@detail.itemID = 30
				@detail.save!
			end
		end

		describe "validations" do

			it "should require a quantity" do
				no_quant_order = OrderDetail.new(:quantity => 0, :spicy => false)
				no_quant_order.orderID = 1
				no_quant_order.typeID = 1
				no_quant_order.groupID = 3
				no_quant_order.itemID = 30
				no_quant_order.save
				no_quant_order.should_not be_valid
			end

		end

		describe "order associations" do
			before(:each) do
				@order = Order.new
				@order.userID = 1
				@order.date = Date.current
				@order.day = Date.current.strftime('%a')
				@order.due = Date.tomorrow
				@order.time = Time.current
				@order.blocked = false
				@order.filled = false
				@order.save

				@detail = @order.order_details.new(:quantity => 2, :spicy => false)
				@detail.orderID = @order.orderID
				@detail.typeID = 1
				@detail.groupID = 3
				@detail.itemID = 30
				@detail.save!
			end

			it "should have an order attribute" do
				@order.should respond_to(:order_details)
			end

			it "should have the right associatied user" do
				@detail.order.should == @order
			end
		end

	end
end
