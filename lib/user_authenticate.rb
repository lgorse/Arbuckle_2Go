module UserAuthenticate

	def user_logout
		logout_url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/website_scripts/logoutRails.php"
		reset_session
		redirect_to(logout_url)
	end

	def authenticate
		redirect_to root_path if session[:user_token].nil?
	end

end