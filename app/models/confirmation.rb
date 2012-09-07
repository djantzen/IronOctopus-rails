class Confirmation < ActiveRecord::Base
  belongs_to :user

  before_create { self.confirmation_uuid = UUID.new.generate }
end
