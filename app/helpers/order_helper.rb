module OrderHelper

	def send_order_flash
		case @order.filled
		when CONFIRMED then
			if @time_data.fetch("validtime") == ORDER_NEXT_DAY
				flash.now[:notice] = "Your order is confirmed. You can edit it until #{@time_data.fetch("cutoff")} on #{@time_data.fetch("nextDay")}."
			else
				flash.now[:notice] = "Pick up your order starting at #{@time_data.fetch("starttime")} in the Deliverables section. You can edit it until #{@time_data.fetch("cutoff")}."
			end
		when SENT then
			flash.now[:notice] = "Pick your order up at Arbuckle's Deliverables section! Don't forget to get a free dessert!"
		end
	end

	def order_pickup_instructions
		if @order.order_details.any?
			if @time_data.fetch("validtime") == ORDER_NEXT_DAY
				"Pick up your order on #{@time_data.fetch("nextDay")} at #{@time_data.fetch("starttime")}"
			else
				"Pick up your order today from #{@time_data.fetch("starttime")} at the Deliverables section"
			end
		else
			"No more orders today. Check in next #{@time_data.fetch("nextDay")}!"
		end
	end

end
