# coding: utf-8


Gem::Specification.new do |o|
  o.name          = "gr8"
  o.version       = "$Release: 0.0.0 $".split[1]
  o.author        = "makoto kuwata"
  o.email         = "kwa(at)kuwata-lab.com"
  o.platform      = Gem::Platform::RUBY
  o.homepage      = "http://kwatch.github.io/gr8/"
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
