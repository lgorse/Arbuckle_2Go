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


	end
end
