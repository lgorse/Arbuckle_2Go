module PagesHelper

	def item_select(item)
		if @order.order_details.any? {|detail| detail.itemID == item.itemID} 
			"selected"
		else
			""
		end
	end

	def combo_status(combo)
		if @order.filled?(combo)
			"combo_filled"
		else
			""
		end
	end

end
