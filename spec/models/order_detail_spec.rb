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


	describe "'CREATE'" do

		before(:each) do
			@order = FactoryGirl.create(:order)
			@attr = {:orderID => @order.orderID, :typeID => 1, :groupID => 3, :itemID => 14,
				:quantity => 2, :spicy => false}
			end

			it 'should create a new instance given a valid attribute' do
				OrderDetail.create!(@attr)
			end

			it 'should require a quantity less than or equal to 10' do
				hi_quant_detail = OrderDetail.new(@attr.merge(:quantity => 11))
				hi_quant_detail.should_not be_valid
			end

			it 'should require a quantity greater than 0' do
				lo_quant_detail = OrderDetail.new(@attr.merge(:quantity => 0))
				lo_quant_detail.should_not be_valid
			end

	end


end

