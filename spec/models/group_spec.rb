# == Schema Information
#
# Table name: ArbuckleGroup
#
#  groupID   :integer          not null, primary key
#  typeID    :integer          not null
#  groupName :string(36)       not null
#  Price     :float
#  Detail    :string(68)       not null
#

require 'spec_helper'

describe Group do

  describe "Group associations" do

    before(:each) do
      @type = FactoryGirl.create(:type)
      3.times do |n|
        FactoryGirl.create(:type)
      end
      5.times do |g|
        @group = FactoryGirl.create(:group, :typeID => @type.typeID)
        FactoryGirl.create(:item, :groupID => @group.groupID)
      end
    end


  	it "should have a type attribute" do
  		@group.should respond_to(:type)
  	end

  	it "should have an items attribute" do
      @group.should respond_to(:items)
  	end


  	it "should be associated with the correct type" do
      @group.type.should == @type
  	end

    it "should have multiple items" do
      @group.items.count.should >= 1
    end

  end
end
