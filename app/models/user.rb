class User < ActiveRecord::Base

  has_secure_password
  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates_presence_of :login, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :login
  validates_uniqueness_of :email

  has_many :routines, :class_name => 'Routine', :foreign_key => 'client_id'
  has_many :routines_created, :class_name => 'Routine', :foreign_key => 'trainer_id'

  has_and_belongs_to_many :clients, :class_name => 'User', :foreign_key => 'client_id', :association_foreign_key => 'trainer_id', :join_table => 'user_relationships'
  has_and_belongs_to_many :trainers, :class_name => 'User', :foreign_key => 'trainer_id', :association_foreign_key => 'client_id', :join_table => 'user_relationships'
end
