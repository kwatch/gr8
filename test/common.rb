# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

$: << File.dirname(__FILE__)

require "stringio"

$DONT_RUN_GR8_APP = true
unless defined?(Gr8)
  File.class_eval do
    load join(dirname(dirname(__FILE__)), "bin", "gr8")
  end
end


def dummy_io(input=nil)
  originals = [$stdin, $stdout, $stderr]
  sin, sout, serr = StringIO.new(input.to_s), StringIO.new, StringIO.new
  $stdin, $stdout, $stderr = sin, sout, serr
  begin
    yield
  ensure
    $stdin, $stdout, $stderr = originals
  end
  return sout.string, serr.string
end
