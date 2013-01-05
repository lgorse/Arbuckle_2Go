require 'spec_helper'

describe OrderController do

	describe "DELETE delete" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID)
			@orderRandom = FactoryGirl.create(:order, :userID => "Not the user")
			@detail1 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => 10)
			@detail2 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:typeID => 1, :groupID => 7)
		end

		it "should destroy all order details" do
			delete :destroy, :orderID => @order
			OrderDetail.where(:detailID => @detail1.detailID).should be_blank
			OrderDetail.where(:detailID => @detail2.detailID).should be_blank
		end

		it "should destroy the order from the orderlist" do
			delete :destroy, :orderID => @order.orderID
			Order.where(:userID => @order.userID).should be_blank
		end

		it "should redirect the user home" do
			delete :destroy, :orderID => @order.orderID
			response.should redirect_to(home_path)

		end

	end



	describe "PUT SEND" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => 2)
			@detail1 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => 10)
			@detail2 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:typeID => 1, :groupID => 7)
		end
		
		it "should change the filled status to CONFIRMED" do
			put :update, :orderID => @order
			Order.find(@order.orderID).filled.should == SENT

		end

		it "should return the user to a thank you screen" do
			put :update, :orderID => @order.orderID
			response.should render_template('order/update')

		end

	end

	describe "GET edit" do

		it "should show all of the order details" do

		end

		it "should save changes to the database" do

		end

		it "should save changes to the database with a filled of PENDING" do

		end

		it "should save all changes to order details" do

		end

	end

end
