class AlternateActivityName < ActiveRecord::Base
  belongs_to :activity
  set_primary_key :activity_id
  before_validation { self.permalink = name.to_identifier }
  validates_uniqueness_of :permalink
  attr_accessible :name
end