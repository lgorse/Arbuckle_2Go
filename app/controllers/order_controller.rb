class OrderController < ApplicationController

	def destroy
		Order.find(params[:orderID]).destroy
		redirect_to home_path
	end

	def update
		@order = Order.find(params[:orderID])
		@order.update_attribute(:filled, SENT)
		
	end

end
