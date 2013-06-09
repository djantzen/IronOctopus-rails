class ActivityType < ActiveRecord::Base
  has_many :activities

  def self.facets
    ActivityType.select("activity_types.name, count(activities.activity_id)")
                .joins("left join activities using(activity_type_id)")
                .group("activity_types.name")
                .order("activity_types.name")
  end

end
