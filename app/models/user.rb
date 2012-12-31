# == Schema Information
#
# Table name: ArbuckleUserList
#
#  userID     :integer          not null, primary key
#  UserName   :string(36)       not null
#  first_name :string(48)       not null
#  last_name  :string(48)       not null
#  e_mail     :string(48)       not null
#  just_sent  :boolean          not null
#

class User < ActiveRecord::Base
	self.table_name = "ArbuckleUserList"
	before_save :default_values
	#attr_accessible :UserName, :e_mail, :first_name, :just_sent, :last_name


	validates :UserName, :presence => true

	def default_values
		self.first_name ||= ''
		self.last_name ||= ''
		self.e_mail ||= ''
	end

end