class BodyPart < ActiveRecord::Base
  has_and_belongs_to_many :activities, :class_name => 'Activity', :foreign_key => 'body_part_id', :association_foreign_key => 'activity_id'
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  def self.all_regions
    BodyPart.find(:all).map { |b| b.region }.uniq    
  end
end
