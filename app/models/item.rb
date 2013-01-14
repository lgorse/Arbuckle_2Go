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
 

  has_many :order_details, :foreign_key => :itemID

   accepts_nested_attributes_for :group, :order_details

  alias_attribute :price, :Price
  alias_attribute :detail, :Detail

  def combo?
    self.group.typeID != 1
  end

end
