# -*- encoding: utf-8 -*-
require File.expand_path('../lib/programr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mauro Cicio, Nicholas H.Tollervey, Ben Minton and Robert J Whitney"]
  gem.email         = ["robertj.whitney@gmail.com"]
  gem.description   = %q{Ruby interpreter for the AIML}
  gem.summary       = %q{ProgramR is a Ruby implementation of an interpreter for the Artificial Intelligence Markup Language (AIML) based on the work of Dr. Wallace and defined by the Alicebot and AIML Architecture Committee of the A.L.I.C.E. AI Foundation (http://alicebot.org}
  gem.homepage      = "http://aiml-programr.rubyforge.org/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "programr"
  gem.require_paths = ["lib"]
  gem.version       = Programr::VERSION
end
