# -*- coding: utf-8 -*-

###
### $Release: 0.1.1 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require_relative "common.rb"
Dir.glob(File.join(File.dirname(__FILE__), "*_test.rb")).each do |fpath|
  require_relative File.basename(fpath)
end
