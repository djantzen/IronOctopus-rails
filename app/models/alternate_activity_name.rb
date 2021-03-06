class AlternateActivityName < ActiveRecord::Base
  belongs_to :activity
  self.primary_key = :activity_id
  before_validation { self.permalink = name.to_identifier }
  validates_uniqueness_of :permalink
  attr_accessible :name

  def to_s
    name
  end
end