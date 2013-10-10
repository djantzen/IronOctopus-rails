class ActivityCitation < ActiveRecord::Base
  belongs_to :activity
  attr_accessible :citation_url
  validates :citation_url, :url => true
end