# -*- coding: utf-8 -*-

task :default => :test


desc "run test scripts"
task :test do
  sh "ruby -Itest test/oktest.rb -ss test/*_test.rb"
end


desc "build gem file"
task :build do
  ver = _get_1st_argument(:build, "version")
  dir = "build/gr8-#{ver}"
  rm_rf dir
  #
  spec = _load_gemspec_file("gr8.gemspec")
  spec.files.each do |fpath|
    new_fpath = "#{dir}/#{fpath}"
    dirpath = File.dirname(new_fpath)
    mkdir_p dirpath unless File.exist?(dirpath)
    cp fpath, new_fpath
  end
  #
  Dir.chdir(dir) do
    spec.files.each do |fpath|
      _edit_file(fpath, ver) {|s|
        s.gsub!(/\$[R]elease:.*?\$/, "$\Release: #{ver} $")
        s.gsub!(/\$[R]elease\$/,     "$\Release: #{ver} $")
        s
      }
    end
    sh "gem build gr8.gemspec"
    mv "gr8-#{ver}.gem", ".."
  end
  #
  puts "** created: #{dir}.gem"
end


desc "edit files to set release number"
task :edit => [:test] do
  ver = _get_1st_argument(:build, "version")
  spec = _load_gemspec_file("gr8.gemspec")
  spec.files.each do |fpath|
    _edit_file(fpath, ver) {|s|
      s.gsub!(/\$[R]elease:.*?\$/, "$\Release: #{ver} $")
      s.gsub!(/\$[R]elease\$/,     "$\Release: #{ver} $")
      s
    }
  end
end


desc "upload gem file to rubygems.org"
task :publish => [:test] do
  puts ""
  print "** Are you sure to release #{gemfile}? [y/N] "
  answer = $stdin.gets()
  if answer =~ /\A[yY]/
    Rake[:build].invoke
    sh "git tag #{ver}"
    sh "git push --tags"
    Dir.chdir "build" do
      sh "gem push #{gemfile}"
    end
  else
    $stderr.puts "** Canceled."
  end
end


## helper functions

def _get_1st_argument(task, argname="argument")
  if ARGV.length == 1
    raise ArgumentError.new("rake #{task}: #{argname} required.")
  end
  arg = ARGV[1]
  ARGV.slice(1, ARGV.length).each{|v| task(v.intern) { } }
  return arg
end

def _load_gemspec_file(filename)
  require "rubygems"
  spec = Gem::Specification::load(filename)
  return spec
end

def _edit_file(fpath, ver)
  File.open(fpath, 'r+') do |f|
    s = f.read()
    s2 = yield s
    f.rewind()
    f.truncate(0)
    f.write(s2)
  end
end
