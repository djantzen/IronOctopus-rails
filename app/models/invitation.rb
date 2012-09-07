class Invitation < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User'
  belongs_to :license
end
