module OrderDetailHelper

	def total_price(quantity, price)
		if !quantity.nil? && !price.nil?
			total_price = number_with_precision((quantity*price), :precision => 2)
			"$#{total_price} for #{quantity} pieces" 
		end
	end

	def define_order_values(detail)
		@detail = detail
		@item = Item.find(@detail.itemID)
		@orderID = @order.orderID
	end

	def quant_selector_max(group)
		@item.combo? ? combo_remaining(group) : CARTE_MAX
	end

	protected

	def combo_remaining(group)
		current_orders =  @detail.order.quant_by_combo(group)
		(Group.order_max(group.groupID) - current_orders).abs

	end

end
