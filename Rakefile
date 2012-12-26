# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # app.redgreen_style = :full
  app.frameworks << 'AVFoundation'
  app.vendor_project 'vendor/SDWebImage', :xcode
  app.vendor_project 'vendor/Base64', :static
  
  app.vendor_project 'vendor/CrittercismSDK', :static, :headers_dir => 'vendor/CrittercismSDK'
  app.frameworks << 'SystemConfiguration'
  app.frameworks << 'Crittercism'

  # The follow flag solves SDWebImage's array subscripting problem. More here:
  # http://spin.atomicobject.com/2012/12/04/linking-against-libarclite-in-ruby-motion/
  app.libs << "-fobjc-arc"

  app.identifier = "com.digitalfilmtree.ScribbeoMotion"
  app.name = 'Scribbeo Motion'
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:landscape_right, :landscape_left]

  app.deployment_target = "5.0" 
end

# On-device Debugging task
# http://www.rubymotion.com/developer-center/articles/debugging/
task :debug do
  system('rake device debug=1')
  # Use below to break before starting app
  # system('rake debug=1 no_continue=1')
end