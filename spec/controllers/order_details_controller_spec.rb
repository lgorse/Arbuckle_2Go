require 'spec_helper'

describe OrderDetailsController do
	
	render_views

	describe "'NEW' form to confirm order detail" do

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

	describe "'CREATE' a new order detail" do

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

		end

		describe "'DELETE'" do

			before(:each) do
				@detail = FactoryGirl.create(:order_detail)
				@item = FactoryGirl.create(:item)
			end


			it "should remove the order detail" do
				lambda do
					delete :destroy, :id => @detail
				end.should change(OrderDetail, :count).by(-1)

			end

			it "should take the user back to home" do
				delete :destroy, :id => @detail
				response.should redirect_to(home_path)
			end
		end


		describe "'PUT' update order detail " do
			before(:each) do
				@order = FactoryGirl.create(:order)
				@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID)
				@attr = {:orderID => @order.orderID, :typeID => 3, :groupID => 3,
				:itemID => 74, :quantity => 7, :spicy => true}
			end

			it "should change the order's attributes" do
				put :update, :id => @detail, :order_detail => @attr
				order = assigns(:order_detail).order
				order_detail = assigns[:order_detail]
				order_detail.should == @detail
			end

		end
	end



