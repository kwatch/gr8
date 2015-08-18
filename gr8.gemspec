# coding: utf-8


Gem::Specification.new do |o|
  o.name          = "gr8"
  o.version       = "$Release: 0.0.0 $".split[1]
  o.author        = "makoto kuwata"
  o.email         = "kwa(at)kuwata-lab.com"
  o.platform      = Gem::Platform::RUBY
  o.homepage      = "http://kwatch.github.io/gr8/"
  o.license       = "MIT Lisense"
  o.summary       = "Brings Ruby power to your command-line"
  o.description   = <<'END'
Gr8 brings Ruby power (such as map, select, inject, grep, min, max, ...)
to your command line. Great.

See http://kwatch.github.io/gr8/ for detail.
END

  o.files         = Dir[*%w[
                      README.md MIT-LICENSE gr8.gemspec setup.rb Rakefile
                      bin/*
                      test/*_test.rb test/common.rb test/test_all.rb
                    ]]
  o.executables   = ["gr8"]
  o.bindir        = ["bin"]
  #o.test_files   = o.files.grep(/^test\//)
  o.test_file     = "test/test_all.rb"

  o.required_ruby_version = '>= 2.0'
  o.add_development_dependency "oktest", "~> 0"
end
