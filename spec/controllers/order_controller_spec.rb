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
				put :update, :id => @order.orderID, :order => {:orderID => @order, :filled => SENT}
				Order.where(:orderID => @order.orderID).size.should == 1
			end

			it "should change the filled status to CONFIRMED" do
				put :update, :id => @order, :order => {:orderID => @order, :filled => SENT}
				Order.find(@order.orderID).filled.should == SENT
			end

			it "should set the day to the proper format" do
				put :update, :id => @order, :order => {:orderID => @order.orderID, :day => @order.day}
				Order.find(@order.orderID).day.should == Date.current.strftime('%a')
			end

			it 'should set the date as appropriate' do
				put :update, :id => @order, :order => {:orderID => @order.orderID, :date => @order.date}
				Order.find(@order.orderID).date.strftime('%Y%m%d').should == Date.current.strftime('%Y%m%d')
			end

			it "should return the user to a thank you screen" do
				put :update, :id => @order, :order => {:orderID => @order.orderID, :day => @order.day, :filled => SENT}
				response.should render_template('order/update')
			end

		end

	end


	describe "GET edit" do
		before(:each) do
			@order = FactoryGirl.create(:order)
			@type = FactoryGirl.create(:type)
			@group = FactoryGirl.create(:group, :typeID => @type.typeID)
			@item = FactoryGirl.create(:item, :groupID => @group.groupID)
			@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => @item.itemID)
			
		end

		describe "if a combo is unfulfilled" do
			before(:each) do
				@combo_type = FactoryGirl.create(:type, :typeID => SPECIAL)
				@combo_group = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
				@combo_item = FactoryGirl.create(:item, :groupID => @combo_group.groupID)
				@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
					:groupID => @combo_group.groupID, :itemID =>@combo_item.itemID,
					:quantity => 3)
			end

			it "should redirect back to the menu if the order has unfulfilled combos" do
				get :edit, :id => @order
				response.should redirect_to home_path
			end

		end

		it 'should be successful' do
			get :edit, :id => @order
			response.should be_success

		end

		it "should show all of the order details" do
			get :edit, :id => @order
			response.body.should have_selector('h3', 
				:text => "Confirm your order")

		end

		it "should have a cancel button" do
			get :edit, :id => @order
			response.body.should have_link('Cancel', href: order_path(assigns(:order)))
		end

		it "should have a confirm button" do
			get :edit, :id => @order
			response.body.should have_link('Confirm', href: order_path(assigns(:order)))
		end

		it "should have a cancel link" do
			get :edit, :id => @order
			response.body.should have_link('Back', :back)

		end

	end

	describe "'CANCEL SPECIAL ORDER'" do
		before(:each)  do
			@order = FactoryGirl.create(:order)
			@combo = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
			@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
			@attr = {:itemID => @item.itemID, :groupID => @combo.groupID, :typeID => @combo.typeID,
				:quantity => 7, :orderID => @order.orderID, :spicy => false}
			end

			it "should be successful" do
				OrderDetail.create!(@attr)
				@order.cancel_special(@combo)
				response.should be_success

			end

			it "should have only not-filled content" do
				OrderDetail.create!(@attr)
				@order.cancel_special(@combo)
				response.body.should_not have_css('th', 'combo_filled')
			end

		end

		describe "CANCEL CHEF SPECIAL ORDER" do
			before(:each)  do
				@order = FactoryGirl.create(:order)
				@chef_special = FactoryGirl.create(:type, :typeID => CHEF_SPECIAL)
				@nigiri = FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => 23)
				@roll= FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => 25)
				@item1 = FactoryGirl.create(:item, :groupID => @nigiri.groupID)
				@item2 = FactoryGirl.create(:item, :groupID => @roll.groupID)
				@attr1 = {:itemID => @item1.itemID, :groupID => @nigiri.groupID, :typeID => @chef_special.typeID,
					:quantity => 3, :orderID => @order.orderID, :spicy => false}
					@attr2 = {:itemID => @item2.itemID, :groupID => @roll.groupID, :typeID => @chef_special.typeID, 
						:quantity => 1, :orderID => @order.orderID, :spicy => false}
					end

					it "should be successful" do
						OrderDetail.create!(@attr1)
						OrderDetail.create!(@attr2)
						@order.cancel_chef_special(@chef_special)
						response.should be_success
					end

					it  "should have only not-filled content" do
						OrderDetail.create!(@attr1)
						OrderDetail.create!(@attr2)
						@order.cancel_chef_special(@chef_special)
						response.body.should_not have_css('th', 'combo_filled')

					end

				end

			end
