# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

$: << File.dirname(__FILE__)

require "oktest"

load File.class_eval { join(dirname(dirname(__FILE__)), "bin", "gr8") }


Oktest.scope do


  topic Enumerable do


    topic '#sum()' do

      spec "[!9izc1] returns sum of numbers." do
        ok {[0, 10, 20, 30].sum} == 60
        ok {[0, 10, 20, 30].sum}.is_a?(Fixnum)
        ok {[0.0, 10, 20, 30].sum} == 60.0
        ok {[0.0, 10, 20, 30].sum}.is_a?(Float)
      end

    end


    topic '#sum_i()' do

      spec "[!01ehd] returns sum of integers, converting values into integer." do
        ok {["10", "20", "30"].sum_i} == 60
        ok {["10", "20", "30"].sum_i}.is_a?(Fixnum)
        ok {["10.0", "20.0", "30.0"].sum_i} == 60
        ok {["10.0", "20.0", "30.0"].sum_i}.is_a?(Fixnum)
      end

    end


    topic '#sum_f()' do

      spec "[!kplnt] returns sum of floats, converting values into float." do
        ok {["10.0", "20.0", "30.0"].sum_f} == 60.0
        ok {["10.0", "20.0", "30.0"].sum_f}.is_a?(Float)
        ok {["10", "20", "30"].sum_f} == 60.0
        ok {["10", "20", "30"].sum_f}.is_a?(Float)
      end

    end


  end


end
