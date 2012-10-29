# -*- encoding: utf-8 -*-
require File.expand_path("../lib/inspector_gadget/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "inspector_gadget"
  s.version     = InspectorGadget::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['mdobrota@tribune.com']
  s.email       = ['mdobrota@tribune.com']
  s.homepage    = "http://rubygems.org/gems/inspector_gadget"
  s.summary     = "Inspect any object's methods by including the module"
  s.description = "Inspect any object's methods"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "inspector_gadget"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
