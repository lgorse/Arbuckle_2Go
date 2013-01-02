class PagesController < ApplicationController


	def home
		redirect_to root_path if cookies[:user_login].nil?
		@user = User.find_by_UserName(cookies[:user_login])
		create_user if (@user.nil?)
		@name = @user.first_name
		@login = @user.UserName
		set_session
	end

	def sign_in
		@auth_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafe/webauthRails-local.php"
	end

	def user_parse
		cookies.permanent[:user_first_name] = params[:first_name]
		cookies.permanent[:user_login] = params[:login]
		cookies.permanent[:user_last_name] = params[:last_name]
		cookies.permanent[:user_e_mail] = params[:e_mail]
		redirect_to home_path
	end

	def create_user
		user = User.new
		user.UserName = cookies[:user_login]
		user.first_name = cookies[:user_first_name]
		user.last_name = cookies[:user_last_name]
		user.e_mail = cookies[:user_e_mail]
		user.just_sent = 0
		user.save
		@user = user
		flash[:notice] = "Welcome to Arbuckle 2Go!"
	end

	def set_session
		session[:user_token] = @user.userID
	end

	def logout
		logout_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/website_scripts/logoutRails.php"
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


end
