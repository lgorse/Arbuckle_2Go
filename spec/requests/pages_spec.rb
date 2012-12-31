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

		it "should not contain a parsing message" do
			visit user_parse_path
			page.should_not have_css("p", :text => "Parsing user information")
		end
	end

	describe "GET/ home" do
		it "should have a visible logout link" do
			visit home_path
			page.should have_css("a", :text =>"Log out")
		end

	end
end
