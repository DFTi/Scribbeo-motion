# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # app.redgreen_style = :full
  app.vendor_project 'vendor/SDWebImage', :xcode
  app.vendor_project 'vendor/Base64', :static
  # app.vendor_project 'vendor/CrittercismSDK', :static, :headers_dir => 'vendor/CrittercismSDK'
  # app.frameworks << 'SystemConfiguration'
  # app.frameworks << 'Crittercism'
  app.frameworks << 'AVFoundation'

  # The follow flag solves SDWebImage's array subscripting problem. More here:
  # http://spin.atomicobject.com/2012/12/04/linking-against-libarclite-in-ruby-motion/
  app.libs << "-fobjc-arc"

  app.identifier = "com.digitalfilmtree.ScribbeoMotion"
  app.name = 'Scribbeo Motion'
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:landscape_right, :landscape_left]

  app.deployment_target = "5.0" 
end