# == Schema Information
#
# Table name: ArbuckleOrderDetails
#
#  DetailID :integer          not null, primary key
#  OrderID  :integer          not null
#  typeID   :integer          not null
#  groupID  :integer          not null
#  itemID   :integer          not null
#  Quantity :integer          not null
#  Spicy    :boolean          not null




class OrderDetail < ActiveRecord::Base
	self.table_name = 'ArbuckleOrderDetails'
	alias_attribute :quantity, :Quantity
	alias_attribute :spicy, :Spicy
	alias_attribute :orderID, :OrderID
	alias_attribute :detailID, :DetailID

  attr_accessible :quantity, :spicy, :orderID, :typeID, :groupID, :itemID, :DetailID, :detailID, :OrderID,:Quantity, :Spicy
  
  validates :quantity, :presence => true, :inclusion => 1..10
  validates :orderID, :presence => true
 

  belongs_to :order, :foreign_key => :OrderID

  belongs_to :item, :foreign_key => :itemID

  belongs_to :group, :foreign_key => :groupID

  belongs_to :type, :foreign_key => :typeID

  accepts_nested_attributes_for :order, :item

  
  

  def combo_master
    Item.find(self.itemID).combo? ? return_combo : nil
  end


  protected

  def return_combo
    case self.typeID
      when SPECIAL then
       Group.find(self.groupID)
      when CHEF_SPECIAL then
        Type.find(self.typeID)
      else 
        nil
    end
  end

end


