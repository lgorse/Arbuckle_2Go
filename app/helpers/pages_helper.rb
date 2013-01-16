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

end
