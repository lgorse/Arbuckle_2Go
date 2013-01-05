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
#



class OrderDetail < ActiveRecord::Base
	self.table_name = 'ArbuckleOrderDetails'
	alias_attribute :quantity, :Quantity
	alias_attribute :spicy, :Spicy
	alias_attribute :orderID, :OrderID

  attr_accessible :quantity, :spicy
  
  validates :quantity, :presence => true, 
  					   :numericality => {:greater_than => 0}

  belongs_to :order, :foreign_key => :OrderID
  accepts_nested_attributes_for :order
end
