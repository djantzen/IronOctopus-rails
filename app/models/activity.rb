class Activity < ActiveRecord::Base  

  belongs_to :activity_type
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :measurements, :through => :activity_sets
  has_many :routines, :through => :activity_sets
  has_many :activity_sets
  has_and_belongs_to_many :body_parts, :class_name => 'BodyPart', :foreign_key => 'activity_id', :association_foreign_key => 'body_part_id'
  has_and_belongs_to_many :implements, :class_name => 'Implement', :foreign_key => 'activity_id', :association_foreign_key => 'implement_id'

  validates_presence_of :name, :on => [:create, :update]
  validates_uniqueness_of :name
end
