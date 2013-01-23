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

end
