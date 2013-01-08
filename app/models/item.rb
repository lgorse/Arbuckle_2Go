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

class Item < ActiveRecord::Base
	self.table_name = "ArbuckleItem"
  belongs_to :group, :foreign_key => "groupID", :include => :type
  accepts_nested_attributes_for :group

  alias_attribute :price, :Price
  alias_attribute :detail, :Detail
end
