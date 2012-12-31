
FactoryGirl.define do

	factory :user do |user|
		user.UserName = "lgorse"
		user.first_name = "Laurent"
		user.last_name = "Gorse"
		user.e_mail = "lgorse@stanford.edu"
		user.just_sent = false
	end

end