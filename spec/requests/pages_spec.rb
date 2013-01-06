require 'spec_helper'

describe "Pages" do
	describe "GET /sign in" do

		before(:each) do
			@url = "https://www.stanford.edu/group/arbucklecafe/cgi-bin/ArbuckleCafe/webauthRails.php"
		end

		it "should have a link to webAuthRails" do
			visit signin_path
			page.should have_content('Authenticate')
		end

	end

	describe "GET/ user_parse" do

	
	end

	describe "GET/ home" do

		
			before(:each) do

				@user = FactoryGirl.create(:user, :UserName => "lgorse")

				@type = FactoryGirl.create(:type)
				3.times do |n|
					FactoryGirl.create(:type)
				end
				5.times do |g|
					@group = FactoryGirl.create(:group, :typeID => @type.typeID)
					FactoryGirl.create(:item, :groupID => @group.groupID)
				end
			end

	end
end
