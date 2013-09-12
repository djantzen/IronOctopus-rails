namespace :days do
  desc "Create day records between start and end dates, e.g. START=2013-01-01 END=2013-12-31"
  task :generate => :environment do

    start_date = Date.parse ENV['START']
    end_date = Date.parse ENV['END']
    (start_date .. end_date).each do |date|
      day = Day.find_or_create(date)
      puts "Created #{day}"
    end
  end
end