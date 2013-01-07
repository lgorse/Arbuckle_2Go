class OrderDetailController < ApplicationController

	
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
		@order_detail = OrderDetail.new(params[:order_detail])
		@order_detail.detailID.blank? ? OrderDetail.create!(params[:order_detail]) : OrderDetail.find(@order_detail.detailID).update_attributes(params[:order_detail])
		redirect_to home_path
	rescue
		redirect_to home_path
	end

	def delete
		OrderDetail.destroy(params[:detail]) unless params[:detail].blank?
		redirect_to home_path
	end


end
