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

require 'spec_helper'

describe Order do
	describe 'POST create' do

		before(:each) do
			FactoryGirl.create(:order)
			@order = Order.last

		end

		it "should return the same order as @order" do
			Order.last.should == @order
		end

		it "should set the close-enough current time" do
			Time.now.strftime('%H:%M').should == @order.time.strftime('%H:%M')
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

		it "should default to filled" do
			@order.filled.should be_false
		end

	end
end
