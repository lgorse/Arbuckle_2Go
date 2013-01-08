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
  
  validates :quantity, :presence => true, 
  					   :inclusion => 1..10
  validates :orderID, :presence => true

  belongs_to :order, :foreign_key => :OrderID
  accepts_nested_attributes_for :order


end
