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
  #accepts_nested_attributes_for :type, :items
end
