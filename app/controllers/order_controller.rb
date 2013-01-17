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
		failure = @order.incomplete_combos?
		if !failure.blank?
			redirect_to home_path, :group => failure.last
		else
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

end
