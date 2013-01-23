require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PagesHelper. For example:
#
# describe PagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PagesHelper do
	
	it "should return the correct flash ON ORDER_NEXT_DAY" do
		@alt_time = {"validtime"=> ORDER_NEXT_DAY, "starttime"=> "11:30", "cutoff" => "10:30","endtime" => "14:00", "nextDay" => "Thursday"}
		assign(:time_data, @alt_time)
		helper.home_flash.should =~ /thursday/i
	end

	it "should flash a NOTICE for TODAY if the order status is ORDER_TODAY" do
		@alt_time = {"validtime"=> ORDER_TODAY, "starttime"=> "11:30", "cutoff" => "10:30","endtime" => "14:00", "nextDay" => "Thursday"}
		assign(:time_data, @alt_time)
		helper.home_flash.should =~ /10:30/i
	end

	it "should flash a NOTICE for LOCKOUT if order status is ORDER_LOCKOUT" do
		@alt_time = {"validtime"=> ORDER_LOCKOUT, "starttime"=> "11:30", "cutoff" => "10:30","endtime" => "14:00", "nextDay" => "Thursday"}
		assign(:time_data, @alt_time)
		helper.home_flash.should =~ /Order blackout period/i
	end
end
