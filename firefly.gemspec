# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firefly/version"

Gem::Specification.new do |s|
  s.name        = "firefly"
  s.version     = Firefly::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ariejan de Vroom"]
  s.email       = ["ariejan@ariejan.net"]
  s.homepage    = "http://github.com/ariejan/firefly"
  s.summary     = %q{FireFly is a simple URL shortner for personal use}
  s.description = %q{FireFly is a simple URL shortner for personal use. It's powered by Sinatra and can be run with any Rack-capable web server.}

  s.rubyforge_project = "firefly"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("sinatra",           ["~> 1.0"])
  s.add_runtime_dependency("dm-core",           ["~> 1.0.2"])
  s.add_runtime_dependency("dm-migrations",     ["~> 1.0.2"])
  s.add_runtime_dependency("dm-transactions",   ["~> 1.0.2"])
  s.add_runtime_dependency("dm-aggregates",     ["~> 1.0.2"])
  s.add_runtime_dependency("dm-mysql-adapter",  ["~> 1.0.2"])
  s.add_runtime_dependency("haml",              ["~> 3.0.18"])

  s.add_development_dependency("rspec",         ["~> 1.3.0"])
  s.add_development_dependency("rack-test",     ["~> 0.5.4"])
end
