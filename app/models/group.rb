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

class Group < ActiveRecord::Base
	self.table_name = "ArbuckleGroup"
  belongs_to :type, :foreign_key => "typeID"
  has_many :items, :foreign_key => "groupID"
  has_many :order_details, :foreign_key => :groupID
  accepts_nested_attributes_for :type, :items

protected

	def self.order_max(groupID)
		case groupID
		when SASHIMI then
			7
		when NIGIRI_CHEF then
			3
		when HAND_ROLL_CHEF then
			1
		else
			10
		end

	end

end
