# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.setup
Bundler.require
require 'rubygems'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # app.redgreen_style = :full
  app.pods { pod 'AFNetworking' }
  app.frameworks << 'AVFoundation'
  app.frameworks << 'MediaPlayer'
  app.frameworks << 'SystemConfiguration'
  app.frameworks << 'Crittercism'
  app.vendor_project 'vendor/CrittercismSDK', :static, :headers_dir => 'vendor/CrittercismSDK'
  app.vendor_project 'vendor/Base64', :static
  
  app.identifier = "com.digitalfilmtree.ScribbeoMotion"
  app.name = 'Scribbeo Pro'
  app.device_family = [:iphone, :ipad]
  app.interface_orientations << :portrait_upside_down

  app.deployment_target = "5.0" 

  
  app.development do
    app.entitlements['get-task-allow'] = true
    # app.provisioning_profile = "/Users/keyvan/Library/MobileDevice/Provisioning Profiles/C3038594-1DA5-4854-BFC3-3EDC798E4DC2.mobileprovision"
    app.codesign_certificate = "iPhone Developer: KEYVAN FATEHI (JKG8TF89PL)"
  end
  
  app.release do
    app.entitlements['get-task-allow'] = false
    # app.provisioning_profile = "/Users/keyvan/Library/MobileDevice/Provisioning Profiles/0A76B6AC-3FF1-4352-BE71-4ADC36DF0FA7.mobileprovision"
    app.codesign_certificate = "iPhone Distribution: KEYVAN FATEHI"
  end
end

# On-device Debugging task
# See file 'debugger_cmds' for more info
task :debug do
  system('rake device debug=1')
  # Use below to break before starting app
  # system('rake debug=1 no_continue=1')
end