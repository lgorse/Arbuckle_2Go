class OrderController < ApplicationController
include UserAuthenticate
include OrderHelper

before_filter :authenticate_send, :only => [:send_order]
before_filter :authenticate_edit, :only => [:edit]

	def destroy
		Order.find(params[:id]).destroy
		flash[:success] = "Order cancelled"
		redirect_to home_path
	end

	def update
		@order = Order.find(params[:id])
		@order.update_order(params[:order][:blocked], params[:order][:filled])
	end

	def edit
		redirect_to send_path and return if @time_data.fetch("validtime") == ORDER_LOCKOUT
		@title = "Review your order then Check out"
		@order.update_order(false, PENDING)
		failure = @order.incomplete_combos?
		if !failure.blank?
			flash[:error] = "#{failure.last.type.typeName} order is incomplete."
			redirect_to home_path, :group => failure.last
		else
			flash[:notice] = "Edit your order or Check out."
			respond_to do |format|
				format.html
				format.js 
			end
		end
	end

	def cancel_special
		@order = Order.find(params[:order])
		@combo = Group.find(params[:combo_id])
		@type = Type.find(@combo.typeID)
		@order.cancel_special(@combo)
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def cancel_chef_special
		@order = Order.find(params[:order])
		@combo = Type.find(params[:combo_id])
		@order.cancel_chef_special(@combo)
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def send_order
		if @order.order_details.any?
			@order.filled == SENT ? @title = "Order filled." : @title = "Order Confirmed"
		else
			@title = "No order confirmed"
		end
		@order.add_combo_hacks
		@order.update_order(false, CONFIRMED) if @order.filled == PENDING unless @time_data.fetch('validtime') == ORDER_LOCKOUT
		send_order_flash
		flash.now[:warning] = "Don't forget to pick up any free dessert from the Deliverables section"
	end

	def logout
		user_logout
	end

end
