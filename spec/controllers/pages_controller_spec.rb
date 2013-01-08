require 'spec_helper'

describe PagesController do
	render_views

	describe "GET 'sign_in'" do

		before(:each) do
			@url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafe/webauthRails.php"
		end

		it "returns http success" do
			get 'sign_in'
			response.should be_success
		end

	end

	describe "GET 'user_parse'" do

		it "must redirect to home" do
			get 'user_parse'
			response.should redirect_to home_path
		end

	end

	describe "GET 'home'" do

		describe "valid login" do

			before(:each) do
				@user = FactoryGirl.create(:user)
				request.session[:user_token] = @user.userID

				@type = FactoryGirl.create(:type)
				3.times do |n|
					FactoryGirl.create(:type)
				end
				5.times do |g|
					@group = FactoryGirl.create(:group, :typeID => @type.typeID)
					FactoryGirl.create(:item, :groupID => @group.groupID)
				end
			end

			it "should be successful" do
				get 'home'
				response.should be_success

			end

			it "must contain user name" do
				get 'home'
				response.body.should have_selector("h3", :text => @user.first_name)
			end


			it "should create a new session" do
				get 'home'
				session[:user_token].should == @user.userID
			end

			it "should lead to the current user" do
				get 'home'
				User.find(session[:user_token]).should == @user
			end

			it "should have a visible logout link" do
				get 'home'
				response.body.should have_css("a", :text =>"Log out")
			end

			it "should have a link to the order confirmation" do
				get 'home'
				response.body.should have_link('Cart', href: edit_order_path(assigns(:order)))

			end

		end

		describe "failed or irregular entry" do

			it "should redirect the user to the signin page if not signed in" do
				get 'logout'
				get 'home'
				response.should redirect_to root_path
			end

		end

		describe "order management" do

			before(:each) do
				@user = FactoryGirl.create(:user)
				request.session[:user_token] = @user.userID

				@type = FactoryGirl.create(:type)
				3.times do |n|
					FactoryGirl.create(:type)
				end
				5.times do |g|
					@group = FactoryGirl.create(:group, :typeID => @type.typeID)
					FactoryGirl.create(:item, :groupID => @group.groupID)
				end
			end

			describe "if an order has not been confirmed" do
				before(:each) do
					@order = FactoryGirl.create(:order, :userID => @user.userID, :filled => 2)
				end

				it "should define it as the session order " do
					get 'home'
					order = assigns(:order)
					order.should == Order.find(@order.orderID)
				end

				it "should have a filled status of 2" do
					get 'home'
					order = assigns(:order)
					order.filled.should == 2
				end

			end

			
			
			describe "if an order doesn't exist" do

				it "should create a new order" do
					get 'home'
					assigns(:order).should_not be_blank
				end

			end

			describe "if an order has been confirmed" do
				before(:each) do
					@order = FactoryGirl.create(:order, :userID => @user.userID)
				end

				it "should define the existing order as the session order" do
					get 'home'
					order = assigns(:order)
					order.should == Order.find(@order.orderID)
				end


				describe "if there are redundant orders" do
					
					before(:each) do
						@order1 = FactoryGirl.create(:order, :userID => @user.userID, :filled => CONFIRMED)
						@order2 = FactoryGirl.create(:order, :userID => @user.userID, :filled => PENDING)
						@order3 = FactoryGirl.create(:order, :userID => 1003)
						@order4 = FactoryGirl.create(:order, :userID => @user.userID, :filled => SENT)
					end

					it "should remove extra orders but create a single one" do
						get 'home'
						Order.where(:userID => @user.userID, :filled => [0,2]).size.should == 1
					end	

					it "should create an initialized basic order" do
						get 'home'
						@order = Order.where(:userID => @user.userID, :filled => [0,2]).first
						@order.attributes.values.any?.should be_true
					end

					it "should create an initial basic order without order details" do
						get 'home'
						@order = Order.where(:userID => @user.userID, :filled => [0,2]).first
						@order.order_details.blank?.should be_true
					end

					it "should not clear filled orders" do
						get 'home'
						Order.where(:userID => @user.userID, :filled => SENT).size.should == 1
					end

				end

			end
		end

	end

	describe "GET 'create'" do


		it "should add the user to the database" do
			lambda do
				get :user_parse, :login => "newguy", :first_name => "New", :last_name => "kid", :e_mail => "in@town.com"
			end.should change(User, :count).by(1)
		end

		it "should flash a welcome message to new users" do
			get :user_parse, :login => "newguy", :first_name => "New", :last_name => "kid", :e_mail => "in@town.com"
			flash[:notice].should =~ /Welcome to Arbuckle 2Go!/i
		end

		

	end

	describe "GET logout" do

		before(:each) do
			@user = FactoryGirl.create(:user)
			request.session[:user_token] = @user.userID
			@type = FactoryGirl.create(:type)

			3.times do |n|
				FactoryGirl.create(:type)
			end

			5.times do |g|
				@group = FactoryGirl.create(:group, :typeID => @type.typeID)
				FactoryGirl.create(:item, :groupID => @group.groupID)
			end

			get 'home'
		end

		it "should transfer the user to Stanford's webauth logout" do
			get 'logout'
			current_path.should_not == logout_path
		end

		it "should delete the session" do
			get 'logout'
			session[:user_token].should == nil
		end

		it "should delete the order cookie" do
			get 'logout'
			cookies.signed[:current_order].should == nil
		end
	end


end