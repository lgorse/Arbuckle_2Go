require 'spec_helper'

describe OrderController do
	render_views

	describe "DELETE delete" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			@order = FactoryGirl.create(:order, :userID => @user.userID)
			@orderRandom = FactoryGirl.create(:order, :userID => "300")
			@detail1 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => 10)
			@detail2 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:typeID => 1, :groupID => 7)
		end

		it "should destroy all order details" do
			delete :destroy, :id => @order
			OrderDetail.where(:detailID => @detail1.detailID).should be_blank
			OrderDetail.where(:detailID => @detail2.detailID).should be_blank
		end

		it "should destroy the order from the orderlist" do
			delete :destroy, :id => @order.orderID
			Order.where(:userID => @order.userID).should be_blank
		end

		it "should redirect the user home" do
			delete :destroy, :id => @order.orderID
			response.should redirect_to(home_path)

		end

	end


	describe "PUT SEND" do

		before(:each) do
		@user = FactoryGirl.create(:user)	
		end

		describe "given an existing order" do

			before(:each) do
				@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => PENDING)
				@item =  FactoryGirl.create(:item)
				@detail1 = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => @item.itemID)
			end

			it "should not create an additional order " do
				put :update, :order => @order, :order => {:orderID => @order, :filled => SENT}
				Order.where(:orderID => @order.orderID).size.should == 1
			end

			it "should change the filled status to CONFIRMED" do
				put :update, :order => @order, :order => {:orderID => @order, :filled => SENT}
				Order.find(@order.orderID).filled.should == SENT
			end

			it "should set the day to the proper format" do
				put :update, :order => @order, :order => {:orderID => @order.orderID, :day => @order.day}
				Order.find(@order.orderID).day.should == Date.current.strftime('%a')
			end

			it 'should set the date as appropriate' do
				put :update, :order => @order, :order => {:orderID => @order.orderID, :date => @order.date}
				Order.find(@order.orderID).date.strftime('%Y%m%d').should == Date.current.strftime('%Y%m%d')
			end

			it "should return the user to a thank you screen" do
				put :update, :order => @order, :order => {:orderID => @order.orderID, :day => @order.day, :filled => SENT}
				response.should render_template('order/update')
			end

		end

	end


	describe "GET edit" do
		before(:each) do
			@order = FactoryGirl.create(:order)
			@item = FactoryGirl.create(:item)
			@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
										 :itemID => @item.itemID)
			
		end
 
		it 'should be successful' do
			get :edit, :id => @order
			response.should be_success

		end

		it "should show all of the order details" do
			get :edit, :id => @order
			response.body.should have_selector('h1', 
							:text => "Order Page")

		end

	end

end
