require 'spec_helper'

describe OrderController do
	render_views

	before(:each) do
		@user = FactoryGirl.create(:user)
		request.session[:user_token] = @user.userID
	end

	describe "DELETE delete" do

		before(:each) do
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

		it "should flash a confirmation message" do
			delete :destroy, :id => @order.orderID
			flash[:success].should =~ /cancelled/i
		end

	end


	describe "PUT UPDATE" do

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

			it "should change the filled status to SENT" do
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
			@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => PENDING)
			@type = FactoryGirl.create(:type)
			@group = FactoryGirl.create(:group, :typeID => @type.typeID)
			@item = FactoryGirl.create(:item, :groupID => @group.groupID)
			@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID,
				:itemID => @item.itemID)
			
		end

		describe "for a well-structured order" do

			it "should redirect the user to the signin page if he is not signed in" do
				get 'logout'
				get 'edit', :id => @order
				response.should redirect_to root_path
			end

			it "should flash the user that he can edit your order or confirm" do
				get :edit, :id => @order
				flash[:notice].should =~ /edit or confirm/i

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
				response.body.should have_link('Cancel Order', href: order_path(@order))
			end

			it "should have a confirm button" do
				get :edit, :id => @order
				response.body.should have_link('Confirm', href: send_path)
			end

			it "should have a cancel link" do
				get :edit, :id => @order
				response.body.should have_link('Back', :back)
			end

			it "should set the order to pending" do
				get :edit, :id => @order
				Order.find(@order.orderID).filled.should == PENDING
			end

		end



		describe "if a combo is unfulfilled" do
			before(:each) do
				@combo_type = FactoryGirl.create(:type, :typeID => SPECIAL)
				@combo_group = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
				@combo_item = FactoryGirl.create(:item, :groupID => @combo_group.groupID)
				@attr = {:orderID => @order.orderID, :typeID => @combo_type.typeID,	:groupID => @combo_group.groupID, :itemID =>@combo_item.itemID,:quantity => 3, :spicy => false}
			end

			it "should redirect back to the menu if the order has unfulfilled combos" do
				OrderDetail.create!(@attr)
				get :edit, :id => @order
				response.should redirect_to home_path
			end

			it "should display an error message if the order is unfulfilled" do
				OrderDetail.create!(@attr)
				get :edit, :id => @order
				flash[:error].should =~ /incomplete/i

			end

			it "should be successful if the order combos are fulfilled" do
				OrderDetail.create!(@attr.merge(:quantity => 7))
				get :edit, :id => @order
				response.should be_success
			end

		end

		describe "if an order is empty" do
			before(:each) do
				@order.order_details.destroy_all
			end

			it "should redirect the user to the order page" do
				get :edit, :id => @order
				response.should redirect_to home_path

			end

			it "should flash the user that his order was empty" do
				get :edit, :id => @order
				flash[:error].should =~ /Fill out an order first/i

			end

			it "should reset the order to PENDING" do
				@order.update_attribute(:filled, CONFIRMED)
				get :edit, :id => @order
				Order.find(@order.orderID).filled.should == PENDING
			end

		end

		describe "if an order is SENT and due today" do

			it "should redirect to the send_page" do
				@order.update_attribute(:filled, SENT)
				@order.update_attribute(:due, Date.current)
				get :edit, :id => @order
				response.should redirect_to send_path

			end

		end

	end

	describe "'CANCEL SPECIAL ORDER'" do
		before(:each)  do
			@order = FactoryGirl.create(:order)
			@combo = FactoryGirl.create(:group, :typeID => SPECIAL, :groupID => SASHIMI)
			@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
			@attr = {:itemID => @item.itemID, :groupID => @combo.groupID, :typeID => @combo.typeID,	:quantity => 7, :orderID => @order.orderID, :spicy => false}
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
			@attr1 = {:itemID => @item1.itemID, :groupID => @nigiri.groupID, :typeID => @chef_special.typeID, :quantity => 3, :orderID => @order.orderID, :spicy => false}
			@attr2 = {:itemID => @item2.itemID, :groupID => @roll.groupID, :typeID => @chef_special.typeID, :quantity => 1, :orderID => @order.orderID, :spicy => false}
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

	describe "'SEND'" do

		describe "regardless of order details"  do
			before(:each)  do
				@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => PENDING)
				@group = FactoryGirl.create(:group)
				@item = FactoryGirl.create(:item, :groupID => @group.groupID)
				@detail = FactoryGirl.create(:order_detail, :groupID => @group.groupID, :itemID => @item.itemID, :orderID => @order.orderID)
			end

			it "should change the order status to CONFIRMED if the order was PREVIOUSLY PENDING" do
				get :send_order, :id => @order.orderID
				Order.find(@order.orderID).filled.should == CONFIRMED
			end

			it "should not add any details for a la carte" do
				lambda do
					get :send_order, :id => @order.orderID
				end.should_not change(OrderDetail, :count)
			end

			it "should redirect the user to the signin page if he is not signed in" do
				get 'logout'
				get 'send_order', :id => @order.orderID
				response.should redirect_to root_path
			end

		end

		describe "fraudulent entry" do

			before(:each) do
				@user_order = FactoryGirl.create(:order, :userID => @user.userID)
				@other_order = FactoryGirl.create(:order, :userID => 10400)
			end

			it "should redirect the user to the user's order page" do
				get 'send_order', :id => @other_order.orderID
				assigns(:order).should == @user_order

			end

		end

		describe "if the order is CONFIRMED" do
			before(:each) do
				@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => CONFIRMED)
				@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID)

			end

			it "should have a cancel link" do
				get 'send_order', :id => @order.orderID
				response.body.should have_link('Cancel Order', :href =>  order_path(@order))

			end

			it "should have an edit link" do
				get 'send_order', :id => @order.orderID
				response.body.should have_link('Edit Order', :href => edit_order_path(@order))

			end

			it "should FLASH a notice" do
				get :send_order, :id => @order.orderID
				flash[:notice].should =~ /10:30/i
			end

		end

		describe "if the order is SENT" do
			before(:each) do
				@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => SENT)
				@detail = FactoryGirl.create(:order_detail, :orderID => @order.orderID)
			end

			it "should not have a cancel link" do
				get 'send_order', :id => @order.orderID
				response.body.should_not have_link('Cancel Order', :href =>  @order)
			end

			it "should not have an edit link" do
				get 'send_order', :id => @order.orderID
				response.body.should_not have_link('Edit Order', :href => edit_order_path(@order))
			end

			it "should FLASH a notice" do
				get :send_order, :id => @order.orderID
				flash[:notice].should =~ /free dessert/i

			end

		end


		describe "if order contains a Special" do

			before(:each)  do
				@order = FactoryGirl.create(:order, :userID => @user.userID)
				@type = FactoryGirl.create(:type, :typeID => SPECIAL)
				@combo = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => SASHIMI)
				@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
				@detail = FactoryGirl.create(:order_detail, :itemID => @item.itemID, :groupID => @combo.groupID, 
					:typeID => @combo.typeID,	:quantity => 7, :orderID => @order.orderID, 
					:spicy => false)
			end

			it "should add a special 'SPECIAL' line to the database" do
				get :send_order, :id => @order.orderID
				OrderDetail.where(:orderID => @order.orderID, :itemID => 0).count.should == 1
			end

			it "(hack) should return the number of details MINUS any item where itemID is 0" do
				get :send_order, :id => @order.orderID
				@order.order_details.where(:groupID=>@combo.groupID).reject{|detail| detail.itemID == 0}.count.should == 1
			end

			it "should only add ONE hack item per order" do
				get :send_order, :id => @order.orderID
				get :send_order, :id => @order.orderID
				@order.order_details.where(:itemID => 0).count.should == 1
			end


		end

		describe "if order contains a chef's Special" do

			before(:each)  do
				@order = FactoryGirl.create(:order, :userID => @user.userID)
				@chef_special = FactoryGirl.create(:type, :typeID => CHEF_SPECIAL)
				@nigiri = FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => NIGIRI_CHEF)
				@roll= FactoryGirl.create(:group, :typeID => @chef_special.typeID, :groupID => HAND_ROLL_CHEF)
				@item1 = FactoryGirl.create(:item, :groupID => @nigiri.groupID)
				@item2 = FactoryGirl.create(:item, :groupID => @roll.groupID)
				@detail1 = FactoryGirl.create(:order_detail, :itemID => @item1.itemID, :groupID => @nigiri.groupID,
					:typeID => @chef_special.typeID, :quantity => 3, :orderID => @order.orderID, 
					:spicy => false)
				@detail2 = FactoryGirl.create(:order_detail, :itemID => @item2.itemID, :groupID => @roll.groupID, 
					:typeID => @chef_special.typeID, :quantity => 1, :orderID => @order.orderID, 
					:spicy => false)
			end

			it "should add a special 'CHEF_SPECIAL' line to the database" do
				get :send_order, :id => @order.orderID
				OrderDetail.where(:orderID => @order.orderID, :groupID => @chef_special.typeID, :itemID => 0).count.should == 1
			end

			it "should only add ONE hack item per order" do
				get :send_order, :id => @order.orderID
				get :send_order, :id => @order.orderID
				@order.order_details.where(:itemID => 0).count.should == 1
			end

			describe "if another combo is added, like this Special" do

				before(:each) do
					get :send_order, :id => @order.orderID
					@type = FactoryGirl.create(:type, :typeID => SPECIAL)
					@combo = FactoryGirl.create(:group, :typeID => @type.typeID, :groupID => SASHIMI)
					@item = FactoryGirl.create(:item, :groupID => @combo.groupID)
					@detail = FactoryGirl.create(:order_detail, :itemID => @item.itemID, :groupID => @combo.groupID, 
						:typeID => @combo.typeID,	:quantity => 7, :orderID => @order.orderID, 
						:spicy => false)
				end

				it "should NOT block the creation of an ITEM HACK for the additional combo" do
					get :send_order,  :id => @order.orderID
					@order.order_details.reject{|detail| detail.itemID == 0}.count.should == 3
				end

			end

		end

	end

end
