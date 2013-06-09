class Implement < ActiveRecord::Base
  has_and_belongs_to_many :activities, :class_name => 'Activity', :foreign_key => 'implement_id', :association_foreign_key => 'activity_id'
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  before_save { self.permalink = name.to_identifier}
  mount_uploader :image, ImageUploader

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:implement]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }

  def self.facets
    Implement.select("implements.category, implements.name, implements.permalink, count(activities.activity_id)")
            .joins("left join activities_implements using(implement_id)")
            .joins("left join activities using(activity_id)")
            .group("implements.category, implements.name, implements.permalink")
            .order("implements.category", "implements.name")
  end

  def self.all_categories
    Implement.all.map { |i| i.category }.uniq
  end

  def to_param
    permalink
  end
end
