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

		before(:each) do
			@attr = {:orderID => 1, :typeID => 1, :groupID => 3, :itemID => 30, :quantity => 3, :spicy => false}
		end

		it "should create a new instance given a valid attribute" do
			OrderDetail.create!(@attr)
		end

		it "should require a quantity" do
			no_quant_order = OrderDetail.new(@attr.merge(:quantity => 0))
			no_quant_order.should_not be_valid
		end

	end
end
