# == Schema Information
#
# Table name: ArbuckleType
#
#  typeID   :integer          not null, primary key
#  typeName :string(36)       not null
#  Price    :float
#

require 'spec_helper'

describe Type do

	describe "associations" do

		before(:each) do
			@type = FactoryGirl.create(:type)
			3.times do |n|
				FactoryGirl.create(:type)
			end
			5.times do |g|
				group = FactoryGirl.create(:group, :typeID => @type.typeID)
				FactoryGirl.create(:item, :groupID => group.groupID)
			end
		end

		it "should have a groups attribute" do
			@type.should respond_to(:groups)
		end

		it "should have many groups" do
			@type.groups.count.should >= 1
		end

		it "should only return groups that have the same typeID" do
			@type.groups.each {|group| group.typeID.should == @type.typeID}
		end

		it "should have cascading access to the group's items as well" do
			@type.groups.first.items.should_not be_nil
		end
	end
end
