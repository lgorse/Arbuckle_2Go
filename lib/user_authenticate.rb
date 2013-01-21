module UserAuthenticate

	def user_logout
		logout_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/website_scripts/logoutRails.php"
		reset_session
		redirect_to(logout_url)
	end

	def authenticate_and_set_order_view
		if session[:user_token].nil?
			redirect_to root_path 
		else
			assign_current_order
			redirect_to send_path if (@order.filled == CONFIRMED || @order.filled == SENT)
		end
	end

	def authenticate
		if session[:user_token].nil?
			redirect_to root_path 
		else 
			assign_current_order
		end
	end

	def assign_current_order
		@user = User.find_by_userID(session[:user_token])
		@order = Order.set_session_order(@user)
	end

end