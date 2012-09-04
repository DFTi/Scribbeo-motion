# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'rubygems'
require 'bundler'
Bundler.require

begin; require 'guard/motion'; rescue LoadError; end

Motion::Project::App.setup do |app|
  app.name = 'Scribbeo'
  app.device_family = :iphone
  app.redgreen_style = :focused
end