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


    topic '#transform()' do

      spec "[!peitw] similar to map() or collect(), make each item as self in block." do
        ok { (1..3).xf {|i| i*10 }    } == [10, 20, 30]
        ok { (1..3).xf {|i| self*10 } } == [10, 20, 30]
      end

    end


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


    topic '#avg()' do

      spec "[!pvi8h] returnns average of numbers." do
        ok {[10, 20, 30].avg} == 20.0
      end

      spec "[!poidi] returns nil when no numbers." do
        ok {[].avg} == nil
      end

    end


    topic '#avg_i()' do

      spec "[!btiat] returns average of numbers, converting values into integer." do
        ok {["10", "20", "30"].avg_i} == 20.0
        ok {["10.1", "20.2", "30.3"].avg_i} == 20.0
      end

      spec "[!892q9] returns nil when no numbers." do
        ok {[].avg_i} == nil
      end

    end


    topic '#avg_f()' do

      spec "[!oqpmc] returns average of numbers, converting values into float." do
        ok {["10", "20", "30"].avg_f} == 20.0
        ok {["10.1", "20.2", "30.3"].avg_f} == 20.2
      end

      spec "[!9bckq] returns nil when no numbers." do
        ok {[].avg_f} == nil
      end

    end


    topic '#xsplit()' do

      spec "[!1pz77] splits each lines with pattern." do
        arr = [" A  10\n", " B  20\n", " C  30\n"]
        ok {arr.xsplit} == [["A", "10"], ["B", "20"], ["C", "30"]]
        arr = [" A: 10\n", " B: 20\n", " C: 30\n"]
        ok {arr.xsplit(/:/)} == [[" A", " 10\n"], [" B", " 20\n"], [" C", " 30\n"]]
      end

      spec "[!wte7b] if block given, use its result as index." do
        arr = [" A  10\n", " B  20\n", " C  30\n"]
        ok {arr.xsplit{1}} == ["10", "20", "30"]
        arr = [" A: 10\n", " B: 20\n", " C: 30\n"]
        ok {arr.xsplit(/:/){0}} == [" A", " B", " C"]
      end

    end


  end


end
