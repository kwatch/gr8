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


end
