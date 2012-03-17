class User < ActiveRecord::Base
  attr_accessible :login, :email, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create
  has_many :routines, :class_name => 'Routine', :foreign_key => 'owner_id'
  has_and_belongs_to_many :students, :class_name => 'User', :foreign_key => 'student_id', :association_foreign_key => 'teacher_id', :join_table => 'user_relationships'
  has_and_belongs_to_many :teachers, :class_name => 'User', :foreign_key => 'teacher_id', :association_foreign_key => 'student_id', :join_table => 'user_relationships'
end
