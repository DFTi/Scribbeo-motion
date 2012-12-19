# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.redgreen_style = :full
  app.vendor_project 'vendor/SDWebImage', :xcode
  
  app.identifier = "com.digitalfilmtree.ScribbeoMotion"
  app.name = 'Scribbeo Motion'
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:landscape_right, :landscape_left]

  app.deployment_target = "5.0" 
end