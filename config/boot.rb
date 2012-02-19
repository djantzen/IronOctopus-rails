require 'rubygems'
require '../IronOctopus-common/lib/string_utils'
require '../IronOctopus-common/lib/log_utils'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
