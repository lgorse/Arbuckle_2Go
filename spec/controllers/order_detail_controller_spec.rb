require 'spec_helper'

describe OrderDetailController do

	describe "'CREATE'" do

		before(:each) do
			@order = FactoryGirl.create(:order)
			@attr = {:orderID => @order.orderID, :typeID => 1,
				:groupID => 3, :itemID => 14,
				:quantity => 2, :spicy => false}
			end

			it 'should create a new instance given a valid attribute' do
				OrderDetail.create!(@attr)
			end

			it 'should require a quantity less than or equal to 10' do
				hi_quant_detail = OrderDetail.new(@attr.merge(:quantity => 11))
				hi_quant_detail.should_not be_valid
			end
	end

end
