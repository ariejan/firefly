# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firefly/version"

Gem::Specification.new do |s|
  s.name        = "firefly"
  s.version     = Firefly::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ariejan de Vroom"]
  s.email       = ["ariejan@ariejan.net"]
  s.homepage    = "http://fireflyrb.com"
  s.summary     = %q{Firefly is your own personal URL shortener for your own domain.}
  s.description = %q{Firefly is your own personal URL shortener for your own domain. It's written in Ruby and powered by Sinatra. You can run it with any Rack-capable web server.}

  s.rubyforge_project = "firefly"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("sinatra",           ["~> 1.2.6"])
  s.add_runtime_dependency("dm-core",           ["~> 1.0.2"])
  s.add_runtime_dependency("dm-migrations",     ["~> 1.0.2"])
  s.add_runtime_dependency("dm-transactions",   ["~> 1.0.2"])
  s.add_runtime_dependency("dm-aggregates",     ["~> 1.0.2"])
  s.add_runtime_dependency("dm-mysql-adapter",  ["~> 1.0.2"])
  s.add_runtime_dependency("haml",              ["~> 3.0.18"])
  s.add_runtime_dependency("escape_utils",      ["~> 0.2.3"])

  s.add_development_dependency("rspec",             ["~> 2.5.0"])
  s.add_development_dependency("rack-test",         ["~> 0.5.4"])
  s.add_development_dependency("dm-sqlite-adapter", ["~> 1.0.2"])
  s.add_development_dependency("database_cleaner",  ["~> 0.6.6"])
end
