module PagesHelper

	def item_select(item)
		@order.order_details.any? {|detail| detail.itemID == item.itemID} ? "selected" : ""
	end

	def combo_status(combo)
		@order.filled?(combo) ? "combo_filled" : ""
	end

	def button_disabled(combo)
		@order.filled?(combo) ? false : true
	end

	def home_flash
		case @time_data.fetch("validtime")
		when ORDER_TODAY then
			flash[:notice] = "Place an order until #{@time_data.fetch("cutoff")}"
		when ORDER_NEXT_DAY then
			flash[:notice] = "Place an order for #{@time_data.fetch("nextDay")}"
		else
			flash[:error] = "Order blackout period. You can order again for #{@time_data.fetch("nextDay")} starting at #{@time_data.fetch("endtime")}"
		end

	end

	def signed_in
		!@user.blank? && @user.userID == session[:user_token]
	end


end
