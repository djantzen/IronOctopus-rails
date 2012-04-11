# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

users = User.create([
                      { :login => 'system', :email => 'system@iron-octopus.com', :password => 'password' },
                       { :login => 'trainer', :email => 'trainer@gmail.com', :password => 'password' },
                       { :login => 'client', :email => 'client@gmail.com', :password => 'password' }
                    ])

users[1].clients << users[2]

activity_types = ActivityType.create([
                                        { :name => 'Cardiovascular' },
                                        { :name => 'Weight Training' },
                                        { :name => 'Rest' },
                                        { :name => 'Plyometrics' }
                                    ])

activities = Activity.create([
                      { :name => 'Bench Press', :activity_type => activity_types[1], :creator => users[0] },
                      { :name => 'Curl and Press', :activity_type => activity_types[1], :creator => users[0] }
                    ])

routines = Routine.create([
                            { :name => 'Push Pull Upper', :goal => 'Balanced upper body workout', :trainer => users[1], :owner => users[2], :client => users[2] }
                          ])

measurements = Measurement.create([
                                      { :resistance => 100 },
                                      { :resistance => 30 }
                                  ])

activity_sets = ActivitySet.create([
                                        {
                                          :routine => routines[0],
                                          :repetitions => 10,
                                          :measurement => measurements[0],
                                          :activity => activities[0],
                                          :position => 1 },
                                        {
                                          :routine => routines[0],
                                          :repetitions => 10,
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