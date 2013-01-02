# == Schema Information
#
# Table name: ArbuckleItem
#
#  itemID      :integer          not null, primary key
#  groupID     :integer          not null
#  itemName    :string(36)       not null
#  Price       :float
#  ComboSubset :boolean          not null
#  Detail      :string(68)       not null
#  Spicy       :string(11)       not null
#

require 'spec_helper'

describe Item do

	describe "item associations" do

		before(:each) do
			type = FactoryGirl.create(:type)
			3.times do |n|
				FactoryGirl.create(:type)
			end
			5.times do |g|
				@group = FactoryGirl.create(:group, :typeID => type.typeID)
				FactoryGirl.create(:item, :groupID => @group.groupID)
			end
			@item = FactoryGirl.create(:item, :groupID => @group.groupID)
		end

		it "should have a group attribute" do
			@item.should respond_to(:group)
		end

		it "should have the correct associated group" do
			@item.group.should == @group
		end

	end
end
