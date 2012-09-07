class License < ActiveRecord::Base
  belongs_to :trainer, :class_name => 'User', :foreign_key => 'trainer_id'
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'

  before_create { self.license_uuid = UUID.new.generate }

  validates :status, :inclusion => { :in => %w(new pending assigned)  }
end
