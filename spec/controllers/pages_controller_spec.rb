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

		before(:each) do
			request.cookies[:user_name] = "Laurent"
			request.cookies[:user_login] = "lgorse"
			@user = User.new
			@user.UserName = cookies[:user_login]
			@user.first_name = cookies[:user_name]
		end

		it "must contain user name" do
			@user.save
			get 'home'
			response.body.should have_selector("p", :text => cookies[:user_name])
		end

		it "must contain user login" do
			@user.save
			get 'home'
			response.body.should have_selector("p", :text => cookies[:user_login])
		end

		it "should create a new session" do
			@user.save
			get 'home'
			session[:user_token].should == @user.userID
		end

		it "should lead to the current user" do
			@user.save
			get 'home'
			User.find(session[:user_token]).should == @user

		end

	end

	describe "GET 'create'" do

		before(:each) do
			@user = nil
			request.cookies[:user_login] = "newguy"
			request.cookies[:user_first_name] = "New"
			request.cookies[:user_last_name] = "kid"
			request.cookies[:user_e_mail] = "in@town.com"
		end


		it "should add the user to the database" do
			lambda do
				get 'home'
			end.should change(User, :count).by(1)
		end

		it "should flash a welcome message to new users" do
			get 'home'
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