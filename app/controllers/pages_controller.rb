class PagesController < ApplicationController

	require "net/http"
	require "uri"
	require "feedzirra"
	require 'htmlentities'

	include UserAuthenticate
	include PagesHelper

	before_filter :authenticate_home, :only => [:home]

	def home
		@title = "Place an order"
		@name = @user.first_name
		@login = @user.UserName
		@name.blank? ? @message = "would god that all the lord's men were prophets" : @message = "Welcome, #{@name}!"
		home_flash
	end

	def sign_in
		@auth_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafe/webauthRails.php"
	end

	def user_parse
		@user = User.find_by_UserName(params[:login])
		create_user if (@user.nil?)
		set_session
		redirect_to home_path
	end

	def create_user
		@user = User.new
		@user.UserName = params[:login]
		@user.first_name = params[:first_name]
		@user.last_name = params[:last_name]
		@user.e_mail = params[:e_mail]
		@user.just_sent = 0
		@user.save
		flash[:notice] = "Welcome to Arbuckle 2Go!"
	end
	

	def logout
		user_logout
	end

	def menu
		@type = Type.find(params[:type])
		@order = Order.find(params[:order])
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def info 
@title = "Here's how it works"
@instructions = get_how_it_works
	end

	def what_else
		@title = "What else is on - Arbuckle's daily menu"
		@day_menu = Feedzirra::Feed.fetch_and_parse("http://www.cafebonappetit.com/rss/menu/269")
	end


	protected
	
	def set_session
		session[:user_token] = @user.userID
	end

	def get_how_it_works
		uri = URI.parse("http://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleInstructions.php")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		http.finish if http.started?
		instructions = JSON.parse(response.body)
	end


end

