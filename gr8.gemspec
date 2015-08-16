# coding: utf-8


Gem::Specification.new do |o|
  o.name          = "gr8"
  o.version       = "$Release: 0.0.0 $".split[1]
  o.author        = "makoto kuwata"
  o.email         = "kwa(at)kuwata-lab.com"
  o.platform      = Gem::Platform::RUBY
  o.homepage      = "https://github.com/kwatch/gr8"
  o.license       = "MIT Lisense"
  o.summary       = "Great command-line utility powered by Ruby"
  o.description   = <<'END'
gr8 is a great command-line utility powered by Ruby.

Example:

    $ cat data
    Haruhi   100
    Mikuru    80
    Yuki     120
    $ cat data | gr8s 'map{|s|s.split()[1]}'
    100
    80
    120
    $ cat data | gr8s 'map{|s|s.split()[1]}.map(&:to_i).sum'
    300
    $ cat data | gr8s 'map{split[1]}.sum_i'
    300
    $ cat data | gr8s -F 'map{self[1]}.sum_i'
    300
    $ cat data | gr8s -C2 'sum_i'
    300

See https://github.com/kwatch/gr8 for details.
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

  o.add_development_dependency "oktest", "~> 0"
end
