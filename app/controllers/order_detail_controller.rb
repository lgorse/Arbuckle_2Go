class OrderDetailController < ApplicationController

	
	def new
		@detail = OrderDetail.new
		#@detail = OrderDetail.create(params[:detail])
	end
end
