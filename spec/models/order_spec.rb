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

require 'spec_helper'

describe Order do

	describe "General order features" do

		before(:each) do
			FactoryGirl.create(:order)
			@order = Order.last

		end

		it "should return the same order as @order" do
			Order.last.should == @order
		end

		it "should set the close-enough current time" do
			diff = ((Time.current - @order.time)%3600/60).to_i
			diff.should <= 1.minute
			
		end

		it "should set today's date" do
			@order.date.should == Date.current
		end

		it "should set the correct day format" do
			@order.day.should == Date.current.strftime('%a')
		end

		it "should default to not blocked" do
			@order.blocked.should_not be_true
		end

		it "should default to sent" do
			@order.filled.should == 0
		end

	end

	describe 'blank_order' do

		before(:each) do
			@user = FactoryGirl.create(:user)
		end


		it "should add an order to the database" do
			lambda do
				Order.blank_order(@user.userID)
			end.should change(Order, :count).by(1)
		end

		it "should be pending" do
			@order = Order.blank_order(@user.userID)
			@order.filled.should == PENDING
		end

		it "should have an orderID" do
			@order = Order.blank_order(@user.userID)
			Order.find(@order.orderID).should_not be_blank
		end

	end


	describe "dependencies" do

		before(:each) do
			@order = Order.new
			@order.userID = 1
			@order.date = Date.current
			@order.day = Date.current.strftime('%a')
			@order.due = Date.tomorrow
			@order.time = Time.current
			@order.blocked = false
			@order.filled = 0
			@order.save

			@detail = @order.order_details.new(:quantity => 2, :spicy => false)
			@detail.orderID = @order.orderID
			@detail.typeID = 1
			@detail.groupID = 3
			@detail.itemID = 30
			@detail.save!
		end

		it "should destroy associated details" do
			@order.destroy
			@order.order_details.should_not exist

		end

	end

	
	describe "CANCEL SPECIAL" do

		before(:each) do
			@order = FactoryGirl.create(:order)
			@combo = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
			@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
			@attr = {:itemID => @item.itemID, :groupID => @combo.groupID, :typeID => @combo.typeID, :quantity => 7, :spicy => false, :orderID => @order.orderID}
		end
		
		it "should remove all order details attached to that order" do
			@order_detail = OrderDetail.create!(@attr)
			lambda do
				@order.cancel_special(@combo)
			end.should change(OrderDetail, :count).by(-1)

		end

		it "should state that the combo is now not filled" do
			@order_detail = OrderDetail.create!(@attr)
			@order.cancel_special(@combo)
			@order.filled?(@combo).should be_false

		end

	end


	describe "'CANCEL CHEF SPECIAL'" do

		before(:each) do
			@order = FactoryGirl.create(:order)
			@chef_special = FactoryGirl.create(:type, :typeID => CHEF_SPECIAL)
			@nigiri = FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => 23)
			@roll= FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => 25)
			@item1 = FactoryGirl.create(:item, :groupID => @nigiri.groupID)
			@item2 = FactoryGirl.create(:item, :groupID => @roll.groupID)
			@detail1 = FactoryGirl.create(:order_detail, :itemID => @item1.itemID,
				:groupID => @nigiri.groupID, :typeID => @chef_special.typeID,
				:quantity => 3, :orderID => @order.orderID)
			@detail2 = FactoryGirl.create(:order_detail, :itemID => @item2.itemID, 
				:groupID => @roll.groupID, :typeID => @chef_special.typeID,
				:quantity => 1, :orderID => @order.orderID)
		end

		it "should remove all order details attached to that order" do
			lambda do
				@order.cancel_chef_special(@chef_special)
			end.should change(OrderDetail, :count).by(-2)

		end

		it "should state that all combos under that type are now invalid" do
			@order.cancel_chef_special(@chef_special)
			@order.filled?(@chef_special).should be_false
		end

	end

	describe "if there is part of a combo ordered" do

		before(:each)  do
			@order = FactoryGirl.create(:order)
			@combo = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
			@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
			@order_detail = FactoryGirl.create(:order_detail, :itemID => @item.itemID,
				:groupID => @combo.groupID, :typeID => @combo.typeID,
				:quantity => 2, :orderID => @order.orderID)
		end

		it "should remove the current order's pending items" do
			lambda do
				@order.cancel_special(@combo)
			end.should change(OrderDetail, :count).by(-1)

		end

	end

end