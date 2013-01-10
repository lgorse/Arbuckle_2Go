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

end
