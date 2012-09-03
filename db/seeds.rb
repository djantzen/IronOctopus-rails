# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

#users = User.create([
#                      { :login => 'system', :email => 'system@iron-octopus.com', :password => 'password' }
#                    ])

ActivityType.delete_all
Unit.delete_all
Metric.delete_all

activity_types = ActivityType.create([
                                        { :name => 'Cardiovascular' },
                                        { :name => 'Cycling' },
                                        { :name => 'Olympic Lift' },
                                        { :name => 'Pilates' },
                                        { :name => 'Plyometric' },
                                        { :name => 'Resistance' },
                                        { :name => 'Sport' },
                                        { :name => 'Stretch' },
                                        { :name => 'Swimming' },
                                        { :name => 'Yoga'}
                                    ])

metrics = Metric.create([
                          { :name => 'None'},
                          { :name => 'Cadence'},
                          { :name => 'Calories'},
                          { :name => 'Distance'},
                          { :name => 'Duration'},
                          { :name => 'Incline'},
                          { :name => 'Level'},
                          { :name => 'Repetitions'},
                          { :name => 'Resistance'},
                          { :name => 'Speed'}
                        ])

units = Unit.create([
                      { :name => 'None', :abbr => 'None', :metric_id => Metric.find_by_name('None') },
                      { :name => 'Degree', :abbr => 'deg', :metric => Metric.find_by_name('Incline') },
                      { :name => 'Kilogram', :abbr => 'kg', :is_metric => true, :metric => Metric.find_by_name('Resistance') },
                      { :name => 'Kilometer', :abbr => 'km', :is_metric => true, :metric => Metric.find_by_name('Distance') },
                      { :name => 'Kilometer per Hour', :abbr => 'kph', :is_metric => true, :metric => Metric.find_by_name('Speed') },
                      { :name => 'Mile', :abbr => 'mi', :metric => Metric.find_by_name('Distance') },
                      { :name => 'Minute', :abbr => 'min', :metric => Metric.find_by_name('Duration') },
                      { :name => 'Meter', :abbr => 'm', :is_metric => true, :metric => Metric.find_by_name('Distance') },
                      { :name => 'Mile per Hour', :abbr => 'mph', :metric => Metric.find_by_name('Speed') },
                      { :name => 'Pound', :abbr => 'lb', :metric => Metric.find_by_name('Resistance') },
                      { :name => 'Revolution per Minute', :abbr => 'rpm', :metric => Metric.find_by_name('Cadence') },
                      { :name => 'Second', :abbr => 'sec', :metric => Metric.find_by_name('Duration') },
                      { :name => '50 Meter Lap', :abbr => '50m lap', :factor => 50, :composed_of => Unit.find_by_name('Meter'),
                        :metric => Metric.find_by_name('Duration') }

                    ])