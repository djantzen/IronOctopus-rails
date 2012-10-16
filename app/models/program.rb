class Program < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id

  has_many :weekday_programs
  has_many :scheduled_programs

  before_validation { self.permalink = self.name.to_identifier }

  validates_presence_of :name
  validates_presence_of :goal
  validates_uniqueness_of :permalink

  def to_param
    permalink
  end

  def to_s
    name
  end

end