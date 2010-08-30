# -*- encoding: utf-8 -*-
require File.expand_path("../lib/opts/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "opts"
  s.version     = Opts::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Simon Menke']
  s.email       = ['simon.menke@gmail.com']
  s.homepage    = "http://rubygems.org/gems/opts"
  s.summary     = "Rack for command line applications"
  s.description = "Rack for command line applications"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "opts"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
