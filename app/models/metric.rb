class Metric < ActiveRecord::Base

  has_and_belongs_to_many :activities
  has_many :units

  def to_s
    name
  end

  def self.list
    Metric.where("name != 'None'").order(:name).all
  end

end
