#!/Users/djantzen/.rvm/rubies/ruby-1.9.3-p392/bin/ruby

# random list of names
# list all activity attributes, anatomy, implements

all_names = %w{ press plod plunder pillage plow vertical horizontal diagonal awesome sad
            woeful happy sexy rad cool skinny jumpy beery prancy fantabulous running jogging trending
            bending flummoxing flapping filtering drinking sinking blinking }

all_activity_types = ActivityType.all
all_attributes = ActivityAttribute.all
all_implements = Implement.all
all_body_parts = BodyPart.all
creator = User.find_by_login("bob_the_trainer")

for i in 1..300 do
  name_length = rand(5)

  names = []
  (1 .. (name_length == 0 ? 1 : name_length)).each do |i|
    index = rand(all_names.length-1)
    names << all_names[index]
  end
  name = names.join(" ")

  type = all_activity_types[rand(all_activity_types.length-1)]
  activity = Activity.new(:name => name, :creator => creator, :activity_type => type)

  attributes_length = rand(5)
  (1 .. (attributes_length == 0 ? 1 : attributes_length)).each do |i|
    index = rand(all_attributes.length-1)
    attribute = all_attributes[index]
    activity.activity_attributes << attribute unless activity.activity_attributes.include?(attribute)
  end

  body_parts_length = rand(all_body_parts.length-1)
  (1 .. (body_parts_length == 0 ? 1 : body_parts_length)).each do |i|
    index = rand(all_body_parts.length-1)
    body_part = all_body_parts[index]
    activity.body_parts << body_part unless activity.body_parts.include?(body_part)
  end

  implements_length = rand(all_implements.length-1)
  (1 .. (implements_length == 0 ? 1 : implements_length)).each do |i|
    index = rand(all_implements.length-1)
    implement = all_implements[index]
    activity.implements << implement unless activity.implements.include?(implement)
  end

  begin
    activity.save
  rescue Exception => e
    puts e.message
  end

end