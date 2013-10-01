class User < ActiveRecord::Base

  has_secure_password

  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates_presence_of :login, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :city, :on => :create
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :login
  validates_uniqueness_of :email

  has_many :routines, :foreign_key => :client_id
  has_many :routines_created, :class_name => 'Routine', :foreign_key => :trainer_id

  has_many :weekday_programs, :through => :routines
  has_many :weekday_programs_created, :through => :routines_created, :source => :weekday_programs
  has_many :scheduled_programs, :through => :routines
  has_many :scheduled_programs_created, :through => :routines_created, :source => :scheduled_programs

  has_and_belongs_to_many :todays_routines, :class_name => 'Routine', :foreign_key => :client_id, :join_table => 'todays_routines'

  has_many :work, :foreign_key => :user_id
  has_many :feedback, :foreign_key => :user_id
  has_many :licenses, :foreign_key => :trainer_id
  has_many :unused_licenses, :class_name => 'License', :foreign_key => :trainer_id, :conditions => "status = 'new'"
  has_many :invitations, :foreign_key => :trainer_id
  has_one :confirmation
  belongs_to :city
  has_many :password_reset_requests
  has_and_belongs_to_many :locations
  has_many :areas, :through => :locations, :order => :name
  has_many :neighborhoods, :through => :locations, :order => :name

  has_and_belongs_to_many :trainers, :class_name => 'User', :foreign_key => :client_id, :association_foreign_key => :trainer_id,
                          :join_table => 'user_relationships', :order => 'last_name, first_name'#, :conditions => [ "trainer_id != client_id" ]
  has_and_belongs_to_many :clients, :class_name => 'User', :foreign_key => :trainer_id, :association_foreign_key => :client_id,
                          :join_table => 'user_relationships'#, :conditions => [ "trainer_id != client_id" ]
  has_one :profile
  has_many :activities_performed, :class_name => "Activity", :through => :work,
           :source => :activity, :uniq => true, :order => :name

  TIME_FORMAT = "%l:%M:%S %P"

  def local_time_from_utc(time)
    time.in_time_zone(timezone.tzid).strftime(TIME_FORMAT)
  end

  def programs
    programs = (weekday_programs + scheduled_programs).inject([]) do |array, n_program|
      array << n_program.program
    end
    programs.uniq
  end

  def timezone
    city.timezone
  end

  def local_time
    Time.now.utc.in_time_zone(timezone.tzid)
  end

  def to_param
    login
  end

  def to_s
    login
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_trainer?
    clients.size > 1
  end
end
