
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
		item.Detail ""
		item.groupID 1
		item.ComboSubset 0
		item.Spicy 0

	end


end