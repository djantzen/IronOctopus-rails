class Device < ActiveRecord::Base
  
  belongs_to :user
  before_create { self.device_uuid = UUID.new.generate }

end
