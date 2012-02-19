# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

users = User.create([
                      { :login => 'system', :email => 'system@iron-octopus.com', :password => 'pw' },
                       { :login => 'trainer', :email => 'trainer@gmail.com', :password => 'pw' },
                       { :login => 'client', :email => 'client@gmail.com', :password => 'pw' }
                    ])

unit = Unit.new({ :name => 'None', :abbr => 'None' })
unit.unit_id = 0
unit.save

units = Unit.create([
                      { :name => 'Pounds', :abbr => 'lb' },
                      { :name => 'Kilograms', :abbr => 'kg' }
                    ])

activity_types = ActivityType.create([
                                        { :name => 'Cardiovascular' },
                                        { :name => 'Weight Training' }
                                    ])

activities = Activity.create([
                      { :name => 'Bench Press', :activity_type => activity_types[1], :creator => users[0] },
                      { :name => 'Curl and Press', :activity_type => activity_types[1], :creator => users[0] }
                    ])

routines = Routine.create([
                            { :name => 'Push Pull Upper', :goal => 'Balanced upper body workout', :creator => users[1], :owner => users[2] }
                          ])

measurements = Measurement.create([
                                      { :resistance => 100, :repetitions => 10, :resistance_unit_id => units[0] },
                                      { :resistance => 30, :repetitions => 10, :resistance_unit_id => units[0] }
                                  ])

activity_sets = ActivitySet.create([
                                        {
                                          :routine => routines[0],
                                          :measurement => measurements[0],
                                          :activity => activities[0],
                                          :position => 1 },
                                        {
                                          :routine => routines[0],
                                          :measurement => measurements[1],
                                          :activity => activities[1],
                                          :position => 2 },
                                        ])

day = Day.find_or_create(Time.new.utc)

work = Work.create([
                    { :user => users[2], :routine => routines[0],
                      :measurement => measurements[0], :activity => activities[0],
                      :start_time => Time.new, :end_time => Time.new + 1.minute, :start_day => day
                    }
                  ])