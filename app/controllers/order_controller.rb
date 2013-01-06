class OrderController < ApplicationController

	def destroy
		Order.find(params[:id]).destroy
		redirect_to home_path
	end

	def update
		@order = Order.find(params[:order][:orderID])
		@order.update_attribute(:date, params[:order][:date])
		@order.update_attribute(:day, params[:order][:day])	
		@order.update_attribute(:due, params[:order][:due])
		@order.update_attribute(:time, params[:order][:time])
		@order.update_attribute(:blocked, params[:order][:blocked])
		@order.update_attribute(:filled, params[:order][:filled])
	end

end
