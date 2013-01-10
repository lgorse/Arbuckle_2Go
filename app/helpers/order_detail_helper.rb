module OrderDetailHelper

	def total_price(quantity, price)
		if !quantity.nil? && !price.nil?
			total_price = number_with_precision((quantity*price), :precision => 2)
			"Item price: $#{total_price}" 
		end
	end

end
