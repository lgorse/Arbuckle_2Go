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

		end

		describe "failed or irregular entry" do

			it "should redirect the user to the signin page if not signed in" do
				get 'logout'
				get 'home'
				response.should redirect_to root_path
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

		it "should transfer the user to Stanford's webauth logout" do
			get 'logout'
			current_path.should_not == logout_path
		end

		it "should delete the session" do
			get 'logout'
			session[:user_token].should == nil
		end
	end


end