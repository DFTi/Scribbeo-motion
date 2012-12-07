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
  app.provisioning_profile = "/Users/keyvan/Library/MobileDevice/Provisioning Profiles/EACD30A9-5725-4871-999E-BCA0BF6CA3B6.mobileprovision"
end