class ActivitySetGroup < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :routine
  has_many :activity_sets, :dependent => :destroy

  def to_s
    "#{group_type} #{name} in #{routine}"
  end

end
