# == Schema Information
#
# Table name: ArbuckleType
#
#  typeID   :integer          not null, primary key
#  typeName :string(36)       not null
#  Price    :float
#

class Type < ActiveRecord::Base
 self.table_name = "ArbuckleType"
  has_many :groups, :foreign_key => "typeID"
  has_many :order_details, :foreign_key => :typeID
  accepts_nested_attributes_for :groups
end
