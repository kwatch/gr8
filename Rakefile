# -*- coding: utf-8 -*-


task :default => :test

desc "run test scripts"
task :test do
  sh "ruby -Itest test/oktest.rb -ss test/*_test.rb"
end


desc "build gem file"
task :build do
  if ARGV.length == 1
    raise ArgumentError.new("rake build: version required.")
  end
  ver = ARGV[1]
  ARGV.slice(1, ARGV.size).each{|v| task(v.to_sym) { } }
  require "rubygems"
  require "fileutils"
  spec = Gem::Specification::load("gr8.gemspec")
  spec.files
  #
  ver = "0.1.0"
  dir = "build/gr8-#{ver}"
  FileUtils.rm_rf dir
  spec.files.each do |fpath|
    new_fpath = "#{dir}/#{fpath}"
    dirpath = File.dirname(new_fpath)
    FileUtils.mkdir_p dirpath unless File.exist?(dirpath)
    FileUtils.cp fpath, new_fpath
  end
  Dir.chdir(dir) do
    spec.files.each do |fpath|
      _edit_file(fpath, ver) {|s|
        s.gsub!(/\$[R]elease:.*?\$/, "$\Release: #{ver} $")
        s.gsub!(/\$[R]elease\$/,     "$\Release: #{ver} $")
        s
      }
    end
    sh "gem build gr8.gemspec"
    FileUtils.mv "gr8-#{ver}.gem", ".."
  end
  puts "** created: #{dir}.gem"
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
