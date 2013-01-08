class OrderController < ApplicationController

	def destroy
		Order.find(params[:id]).destroy
		redirect_to home_path
	end

	def update
		#@order = Order.update_order(:order => params[:order])
		@order = Order.find(params[:order][:orderID])
		@order.update_order(params[:order])
	end

	def edit
		@order = Order.find(params[:id])

	end

end
