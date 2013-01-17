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
			@attr = {:orderID => @order.orderID, :typeID => 1, :groupID => 3, :itemID => 14, :quantity => 2, :spicy => false}
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

	describe "validations" do
		before(:each) do
			@order = FactoryGirl.create(:order)
			@type = FactoryGirl.create(:type, :typeID => SPECIAL)
			@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => SASHIMI)
			@item = FactoryGirl.create(:item, :groupID => @group.groupID)
			@attr = {:typeID => @type.typeID, :groupID => @group.groupID, :spicy => false,:itemID => @item.itemID, :orderID => @order.orderID, :quantity => 7}
		end



		it "should reject quantities above the maximum" do
			@detail = OrderDetail.create!(@attr.merge(:quantity => 10))
			@detail.should_not be_valid

		end

		it "should accept quantities within the maximum" do
			@detail = OrderDetail.create!(@attr)
			@detail.should be_valid
		end
	end



	describe "COMBO ORDER MANAGEMENT" do

		

		describe "'COMBO?'" do


			describe "'if the item belongs to a Special combo'" do

				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 3)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => 21)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
				end

				it "should return true if the order_detail belongs to a combo" do
					@item.combo?.should be_true

				end

			end

			describe "if the item belongs to a Chef Special combo" do

				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 5)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => 25)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
				end

				it "should return true if the order_detail belongs to a combo" do
					@item.combo?.should be_true

				end


			end

			describe "when the item is A la carte" do
				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 1)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
				end


				it "should return false" do
					@item.combo?.should be_false
				end

			end
		end	


		describe "'COMBO_MASTER'" do

			describe "for a Chef Special" do

				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 3)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => 21)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
					@order = FactoryGirl.create(:order)
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID, 
						:itemID => @item.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID)


				end



				it "should return the determining criterion for the combo (a type or a group)" do
					@detail.combo_master.should == @group

				end

			end

			describe "for a Special" do

					before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 5)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => 25)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
					@order = FactoryGirl.create(:order)
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID, 
						:itemID => @item.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID)

				end

				it "should return the determining criterion for the combo (a type or a group)" do
					@detail.combo_master.should == @type
				end

			end

			describe "for A la Carte" do
				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => 1)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID)
					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
					@order = FactoryGirl.create(:order)
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID, 
						:itemID => @item.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID)

				end

				it "should return nil" do
					@detail.combo_master.should == nil
				end

			end

		end

		describe "'FILLED?'" do

			describe "'FOR A TYPE:'" do
				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => CHEF_SPECIAL)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => NIGIRI_CHEF)
					@group2 = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => HAND_ROLL_CHEF)

					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
					@item2 = FactoryGirl.create(:item,  :groupID => HAND_ROLL_CHEF, :itemID => 12)

					@order = FactoryGirl.create(:order)
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID, 
						:itemID => @item.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID, :quantity => 3)
					@attr = {:orderID => @order.orderID, 
						:itemID => @item2.itemID, :groupID => HAND_ROLL_CHEF,
						:typeID => @type.typeID, :quantity => 1, :spicy => false}

				end

				it "should return the type as the combo master" do
					@detail.combo_master.should == Type.find(CHEF_SPECIAL)

				end

				it 'should return true if the nested group quantities amount to required sum' do
					@new_detail = OrderDetail.create!(@attr)
					@order.filled?(@new_detail.combo_master).should be_true
				end

				it 'should return false if the nested group quantities do not add up' do
				@order.filled?(@detail.combo_master).should be_false
				end

			end


			describe "'FOR A GROUP: '" do
				before(:each) do
					@type =  FactoryGirl.create(:type,  :typeID => SPECIAL)
					@group = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => SASHIMI)

					@item = FactoryGirl.create(:item, :groupID => @group.groupID)
					@item2 = FactoryGirl.create(:item,  :groupID => @group.groupID, :itemID => 12)

					@order = FactoryGirl.create(:order)
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID, 
						:itemID => @item.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID, :quantity => 5)
					@attr = {:orderID => @order.orderID, 
						:itemID => @item2.itemID, :groupID => @group.groupID,
						:typeID => @type.typeID, :quantity => 2, :spicy => false}

				end

				it 'should return true if the items are equal to the required number' do
					@new_detail = OrderDetail.create!(@attr)
					@order.filled?(@new_detail.combo_master).should be_true
				end

				it 'should return false if the items do not add up' do
					@new_detail = OrderDetail.create!(@attr.merge(:quantity => 1))
					@order.filled?(@new_detail.combo_master).should be_false
				end

				it "should return the quantity ordered up to this point" do
					@new_detail = OrderDetail.create!(@attr.merge(:quantity => 1))
					quant_sum = @new_detail.quantity + @detail.quantity
					@order.quant_by_combo(@new_detail.group).should ==  quant_sum

				end

			end

		end

	end

end

