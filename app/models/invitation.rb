class Invitation < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User'
  belongs_to :license

  before_create { self.invitation_uuid = UUID.new.generate }
end
