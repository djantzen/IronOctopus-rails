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

  def self.all_regions
    BodyPart.all.map { |b| b.region }.uniq
  end

  def to_param
    permalink
  end
end
