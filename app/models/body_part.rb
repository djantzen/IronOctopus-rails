class BodyPart < ActiveRecord::Base
  has_and_belongs_to_many :activities
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  before_save { self.permalink = name.to_identifier}

  def self.all_regions
    BodyPart.all.map { |b| b.region }.uniq
  end

  def to_param
    permalink
  end
end
