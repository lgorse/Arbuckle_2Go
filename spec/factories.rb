
FactoryGirl.define do

	factory :user do |user|
		user.UserName  "lgorse"
		user.first_name "Laurent"
		user.last_name  "Gorse"
		user.e_mail  "lgorse@stanford.edu"
		user.just_sent false
	end	

	factory :type do |type|
		type.typeName "Test type"
	end

	factory :group do |group|
		group.groupName "Test group"
		group.typeID 1
		group.Detail ""
	end

	factory :group_with_item, :parent => :group do |group|
		group.after_create{|g| Factory(:item, :type => t)}
	end

	factory :item do |item|
		item.itemName "Test item"
		item.Detail "Tasty treat"
		item.groupID 1
		item.ComboSubset 0
		item.Spicy 0

	end

	factory :order do |order|
		order.userID 1
		order.date Date.current
		order.day Date.current.strftime('%a')
		order.time Time.current
		order.due Order.set_due_date("validtime"=> ORDER_TODAY, "starttime"=> "11:30", "cutoff" => "10:30", "endtime" => "14:00", "nextDay" => "Thursday" )
		order.blocked false
		order.filled 0
	end

	factory :order_detail do |detail|
		detail.orderID 1
		detail.typeID 3
		detail.groupID 2
		detail.itemID 4
		detail.quantity 5
		detail.spicy false
	end


end