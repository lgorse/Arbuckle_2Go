# == Schema Information
#
# Table name: ArbuckleUserList
#
#  userID     :integer          not null, primary key
#  UserName   :string(36)       not null
#  first_name :string(48)       not null
#  last_name  :string(48)       not null
#  e_mail     :string(48)       not null
#  just_sent  :boolean          default(FALSE), not null
#

require 'spec_helper'

describe User do
  

  describe "User validation" do

  	it "should have a user name" do
  		no_login_user = User.new
      no_login_user.UserName = ""
  		no_login_user.should_not be_valid
  	end

  end
end
