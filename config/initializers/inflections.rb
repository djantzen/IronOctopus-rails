# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
 ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#     inflect.uncountable %w( fish sheep )
     inflect.plural "feedback", "feedback"
     inflect.singular "feedback", "feedback"
     inflect.plural "work", "work"
     inflect.singular "work", "work"
     inflect.plural "Kilometer per Hour", "Kilometers per Hour"
     inflect.singular "Kilometers per Hour", "Kilometer per Hour"
     inflect.plural "Mile per Hour", "Miles per Hour"
     inflect.singular "Miles per Hour", "Mile per Hour"
     inflect.plural "Revolution per Minute", "Revolutions per Minute"
     inflect.singular "Revolutions per Minute", "Revolution per Minute"
     inflect.plural "None", "None"
     inflect.singular "None", "None"
end
