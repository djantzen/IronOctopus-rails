class PasswordResetRequest < ActiveRecord::Base
  belongs_to :user
  before_create { self.password_reset_request_uuid = UUID.new.generate }
end
