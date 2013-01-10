class OrderController < ApplicationController

	def destroy
		Order.find(params[:id]).destroy
		redirect_to home_path
	end

	def update
		@order = Order.find(params[:id])
		@order.update_order(params[:order])
	end

	def edit
		@title = "Confirm your order"
		@order = Order.find(params[:id])
		respond_to do |format|
			format.html
			format.js 
		end
	end

end
