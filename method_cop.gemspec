# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "method_cop/version"

Gem::Specification.new do |s|
  s.name        = "method_cop"
  s.version     = MethodCop::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill Abney"]
  s.email       = ["bill@billfloat.com"]
  s.homepage    = "http://github.com/billfloat/method_cop"
  s.summary     = %q{Arrest methods that break the rules.}
  s.description = %q{Prevents methods from running which have been guarded against by a callback specified at the beginning of the class.}

  s.rubyforge_project = "method_cop"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
