# http://stackoverflow.com/questions/5307463/rails-on-passenger-not-recognizing-rvm
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname(__FILE__))
  rescue LoadError
    raise "RVM ruby lib is currently unavailable."
  end
end

# This assumes Bundler 1.0+
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'