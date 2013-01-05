class OrderController < ApplicationController

	def destroy
		TempOrder.delete(@order)
		render 'pages/home'
	end

	def show
@user = User.find(session[:user_token])
		@order = TempOrder.find(@user.userID)
	end

	def clear
	end

	def send
	end
end
