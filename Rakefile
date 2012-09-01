# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'rubygems'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'Scribbeo'
  app.device_family = :iphone
  app.vendor_project "vendor/HostToIP", :xcode, headers_dir:"HostToIP"
end

hide_sim_script = %{
  tell application "Finder"
    set visible of process "iOS Simulator" to false
    repeat while (visible of process "iOS Simulator" is false)
      delay 0.1
    end repeat
    set visible of process "iOS Simulator" to false
  end tell
}

task :hss do
  fork { system("osascript -e '#{hide_sim_script}'") }
end