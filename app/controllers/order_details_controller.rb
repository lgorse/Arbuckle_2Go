class OrderDetailsController < ApplicationController

	
	def new
		@item = Item.find(params[:item])
		@orderID = params[:orderID]

		@detail = OrderDetail.find_or_initialize_by_OrderID_and_itemID(@orderID, @item.itemID)
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js
		end
	end

	def create
		OrderDetail.create!(params[:order_detail])
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def destroy
		OrderDetail.find(params[:id]).destroy unless params[:id].blank?
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

	def show
		@detail = params[:id]
	end

	def update
		@order_detail = OrderDetail.find(params[:id])
		@order_detail.update_attributes!(params[:order_detail])
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js 
		end
	end

end
