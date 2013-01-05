class PagesController < ApplicationController

	before_filter :authenticate, :only => [:home]

	def home
		set_user
		set_order
		@name = @user.first_name
		@login = @user.UserName
	end

	def sign_in
		@auth_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafe/webauthRails-local.php"
	end

	def user_parse
		cookies.permanent.signed[:user_first_name] = params[:first_name]
		cookies.permanent.signed[:user_login] = params[:login]
		cookies.permanent.signed[:user_last_name] = params[:last_name]
		cookies.permanent.signed[:user_e_mail] = params[:e_mail]
		@user = User.find_by_UserName(cookies.signed[:user_login])
		create_user if (@user.nil?)
		set_session
		redirect_to home_path
	end

	def create_user
		@user = User.new
		@user.UserName = cookies.signed[:user_login]
		@user.first_name = cookies.signed[:user_first_name]
		@user.last_name = cookies.signed[:user_last_name]
		@user.e_mail = cookies.signed[:user_e_mail]
		@user.just_sent = 0
		@user.save
		flash[:notice] = "Welcome to Arbuckle 2Go!"
	end

	

	def logout
		logout_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/website_scripts/logoutRails.php"
		cookies.delete(:user_login)
		cookies.delete(:user_first_name)
		cookies.delete(:user_last_name)
		cookies.delete(:user_e_mail)
		reset_session
		redirect_to(logout_url)
	end

	def menu
		@type = Type.find(params[:type])
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def items
		@item = Item.find(params[:item])
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js
		end
	end

	def order_details
		@new_item = params[:f]
	end

	protected

	def authenticate
		redirect_to root_path if session[:user_token].nil?
	end

	def set_user
		@user = User.find_by_userID(session[:user_token])
	end

	def set_session
		session[:user_token] = @user.userID
	end

	def set_order
		order_array = Order.where(:userID => @user.userID, :filled => [PENDING,CONFIRMED])

		if order_array.size > 1
			flash[:error] = "There was a problem with your pending order. Try again. Your pending order has been deleted."
			Order.destroy_all(:userID => @user.userID, :filled => [PENDING, CONFIRMED])
			render 'pages/home'
		end

		order_array.blank? ? @order = Order.new : @order = order_array.first	
	end


end

