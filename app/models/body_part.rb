class BodyPart < ActiveRecord::Base
  has_and_belongs_to_many :activities
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  before_save { self.permalink = name.to_identifier}
  mount_uploader :image, ImageUploader

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:body_part]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }
  validates :region, :length => {
    :minimum => VALIDATIONS[:region][:minlength].to_i,
    :maximum => VALIDATIONS[:region][:maxlength].to_i
  }

  def self.facets
    BodyPart.select("body_parts.body_part_id, body_parts.region, body_parts.name, body_parts.permalink, body_parts.image, count(activities.activity_id)")
            .joins("left join activities_body_parts using(body_part_id)")
            .joins("left join activities using(activity_id)")
            .group("body_parts.body_part_id, body_parts.region, body_parts.name, body_parts.permalink, body_parts.image")
            .order("body_parts.region, body_parts.name")
  end

  def self.all_regions
    BodyPart.all.map { |b| b.region }.uniq
  end

  def to_param
    permalink
  end
end
