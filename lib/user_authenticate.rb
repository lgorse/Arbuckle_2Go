module UserAuthenticate

	def user_logout
		logout_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/website_scripts/logoutRails.php"
		reset_session
		redirect_to(logout_url)
	end

	def authenticate_home
		if session[:user_token].nil?
			redirect_to root_path 
		else
			assign_current_order
			redirect_to send_path if (@order.filled == CONFIRMED || @time_data.fetch("validtime") == ORDER_LOCKOUT)
		end
	end

	def authenticate_send
		if session[:user_token].nil?
			redirect_to root_path 
		else 
			assign_current_order
			check_order_nil unless @time_data.fetch("validtime") == ORDER_LOCKOUT			
		end
	end

	def authenticate_edit
		if session[:user_token].nil?
			redirect_to root_path 
		else 
			assign_current_order
			check_order_nil
		end
	end

	def assign_current_order
		@user = User.find_by_userID(session[:user_token])
		@time_data = Order.time_stamp
		@order = Order.set_session_order(@user, @time_data)
	end

	def check_order_nil
		if @order.order_details.blank?
			@order.update_attribute(:filled, PENDING)
			flash[:error] = "Your order is empty!"
			redirect_to home_path
		end
	end
end