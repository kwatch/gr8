# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require_relative "common"
require "oktest"



Oktest.scope do


  topic Kernel do

    topic 'fu()' do

      spec "[!ktccp] returns FileUtils class object." do
        ok {fu} == FileUtils
      end

    end

  end


  topic String do


    topic '#q()' do

      spec "[!ejo5y] quotes string with single-quoation." do
        ok {"hom".q} == "'hom'"
      end

      spec "[!ageyj] escapes single-quotation characters." do
        ok {"'hom'".q} == "'\\'hom\\''"
      end

    end


    topic '#qq()' do

      spec "[!wwvll] quotes string with double-quotation." do
        ok {'hom'.qq} == '"hom"'
      end

      spec "[!rc66j] escapes double-quotation characters." do
        ok {'"hom"'.qq} == '"\"hom\""'
      end

    end


  end


  topic Object do

    topic '_' do

      spec "[!wvemx] returns self object." do
        s = "hom"
        ok {s}.same?(s)
        ok {s}.NOT.same?(s+"")
      end

    end

  end


  topic Gr8::EnumWrapper do


    topic '#each()' do

      spec "[!hloy1] splits each line into array." do
        enum = ["A:10:x", "B:20:y", "C:30:z"]
        wrapper = Gr8::EnumWrapper.new(enum, /:/)
        ok {wrapper.map {|x| x }} == [["A","10","x"], ["B","20","y"], ["C","30","z"]]
        #
        enum = ["A 10 x", "  B  20  y", "C\t30\tz"]
        wrapper = Gr8::EnumWrapper.new(enum)
        ok {wrapper.map {|x| x }} == [["A","10","x"], ["B","20","y"], ["C","30","z"]]
      end

      spec "[!c22km] chomps each lin before splitting." do
        enum = ["A:100\n", "B:200\n", "C:300\n"]
        wrapper = Gr8::EnumWrapper.new(enum, /:/)
        ok {wrapper.map {|x| x }} == [["A", "100"], ["B", "200"], ["C", "300"]]
        #
        enum = ["A 10 x\n", "  B  20  y\n", "C\t30\tz\n"]
        wrapper = Gr8::EnumWrapper.new(enum)
        ok {wrapper.map {|x| x }} == [["A","10","x"], ["B","20","y"], ["C","30","z"]]
      end

      spec "[!m411f] selects column when column number specified." do
        enum = ["A 10 x\n", "  B  20  y\n", "C\t30\tz\n"]
        wrapper = Gr8::EnumWrapper.new(enum, nil, 2)
        ok {wrapper.map {|x| x }} == ["10", "20", "30"]
      end

    end


  end


end
