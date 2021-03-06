# -*- coding: utf-8 -*-

task :default => :test


desc "run test scripts"
task :test do
  sh "ruby -Itest test/oktest.rb -ss test/*_test.rb"
end


desc "build gem file"
task :build do
  spec = _load_gemspec_file("gr8.gemspec")
  ver = spec.version
  dir = "build/gr8-#{ver}"
  rm_rf dir
  #
  spec.files.each do |fpath|
    new_fpath = "#{dir}/#{fpath}"
    dirpath = File.dirname(new_fpath)
    mkdir_p dirpath unless File.exist?(dirpath)
    cp fpath, new_fpath
  end
  #
  Dir.chdir(dir) do
    sh "gem build gr8.gemspec"
    mv "gr8-#{ver}.gem", ".."
  end
  #
  puts "** created: #{dir}.gem"
end


namespace :release do


  desc "edit files to set release number"
  task :edit do
    ver = _get_1st_argument(:build, "version")
    curr_branch = `git branch --contains=HEAD`.split()[1]
    curr_branch =~ /(\d+\.\d+)$/  or
      raise ArgumentError.new("ERROR: current branch (#{curr_branch}) seems non-release branch.")
    branch_num = $1
    ver.start_with?(branch_num)  or
      raise ArgumentError.new("ERROR: version '#{ver}' not match to branch ('#{curr_branch}).")
    spec = _load_gemspec_file("gr8.gemspec")
    spec.files.each do |fpath|
      _edit_file(fpath, ver) {|s|
        s.gsub!(/\$[R]elease:.*?\$/, "$\Release: #{ver} $")
        s.gsub!(/\$[R]elease\$/,     "$\Release: #{ver} $")
        s
      }
    end
    puts ""
    puts "Finished."
    puts ""
    push "Next action:"
    push "  $ git commit -a -m 'ruby: release preparation for #{ver}.'"
    push "  $ rake release:publish"
  end


  desc "upload gem file to rubygems.org"
  task :publish => [:test] do
    spec = _load_gemspec_file("gr8.gemspec")
    ver = spec.version
    gemfile = "gr8-#{ver}.gem"
    puts ""
    print "** Are you sure to publish #{ver}? [y/N] "
    answer = $stdin.gets()
    if answer =~ /\A[yY]/
      Rake::Task[:build].invoke
      sh "git tag ruby-#{ver}"
      sh "git tag -d ruby-current"
      sh "git tag ruby-current"
      sh "git push --tags"
      Dir.chdir "build" do
        sh "gem push #{gemfile}"
      end
    else
      $stderr.puts "** Canceled."
    end
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
