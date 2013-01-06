class OrderDetailController < ApplicationController

	
	def new
		@item = Item.find(params[:item])
		@orderID = params[:orderID]
		@detail = OrderDetail.new
		respond_to do |format|
			format.html {redirect_to home_path}
			format.js
		end
	end
end
