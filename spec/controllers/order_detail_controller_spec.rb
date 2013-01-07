require 'spec_helper'

describe OrderDetailController do
	render_views



	describe "instantiates an order detail" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID)
			@selected_item = FactoryGirl.create(:item)
		end

		describe "when the order detail hasn't been created" do

			it "should instantiate a new order detail" do
				get 'new', :orderID => @order.orderID, :item => @selected_item
				assigns(:detail).detailID.should be_blank
			end
		end


		describe "when the order detail already exists" do

			before(:each) do
				@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
					:itemID => @selected_item.itemID)

			end

			it "should use a pre-existing order" do
				get 'new', :orderID => @order.orderID, :item => @selected_item
				assigns(:detail).detailID.should == @detail.detailID
			end

		end

	end

	describe "create a new order detail" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID)
			@selected_item = FactoryGirl.create(:item)
			@attr = {:orderID => @order.orderID, :typeID => 3, :groupID => 3,
				:itemID => @selected_item.itemID, :quantity => 7, :spicy => false}
			end

			describe "when the detail did not already exist" do

				it "should add a new order detail" do
					@order_detail = OrderDetail.new
					@order_detail.attributes = @attr
					lambda do
						post 'create', :order_detail => @order_detail.attributes
					end.should change(OrderDetail, :count).by(1)
				end
			end

			describe "when the detail already exists" do

				before(:each) do
					@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
						:itemID => @selected_item.itemID)

				end

				it "should not add an entry to the database" do
					lambda do
						post 'create', :order_detail => @detail.attributes
					end.should_not change(OrderDetail, :count)

				end

				it "should have the same ID as the pre-existing order" do
					post 'create', :order_detail => @detail.attributes
					assigns(:order_detail).detailID.should == @detail.detailID
				end
			end

		end

		describe "'DELETE'" do

			before(:each) do
				@detail = FactoryGirl.create(:order_detail)
				@item = FactoryGirl.create(:item)
			end

			
			it "should remove the order detail" do
				lambda do
					delete :delete, :id => @detail.detailID
				end.should change(OrderDetail, :count).by(-1)

			end

			it "should take the user back to home" do
				delete :delete, :id => @detail.detailID
				response.should redirect_to(home_path)
			end
		end


	end

=begin
		describe "should show order detail informations" do

			before(:each) do
				@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID)
				@type = FactoryGirl.create(:type)
				@group = FactoryGirl.create(:group, :typeID => @type.typeID)
				@item = FactoryGirl.create(:item, :groupID => @group.groupID)

			end

			it "should show the order item name" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_content(@item.itemName)
			end

			it "should show the order group name" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_selector("detail_group", :text => @item.group.groupName)

			end

			it "should show the order type name" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_css("p", :text => @item.group.type.typeName)
			end

			it "should show the order detailed description" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_selector(".detail_description", :text => @item.detail)

			end

			it "should show the item price" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_selector(".detail_item_price", :text => @item.price)
			end

			it "should show the total price" do
				get 'new', :orderID => @order.orderID, :item => @item
				response.body.should have_selector("detail_total_price",  :text => "Stub")

			end

		end
=end