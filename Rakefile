# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'bundler'
Bundler.require

require 'guard/motion'

Motion::Project::App.setup do |app|
  app.redgreen_style = :full

  app.identifier = "com.digitalfilmtree.ScribbeoMotion"
  app.name = 'Scribbeo Motion'
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:landscape_right, :landscape_left]

  app.deployment_target = "5.0" 
  # app.provisioning_profile = "/Users/keyvan/Library/MobileDevice/Provisioning Profiles/4CACEC1A-FB3C-4808-9C5D-17D22A74A859.mobileprovision"
end