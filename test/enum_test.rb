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


    topic '#sed()' do

      spec "[!c7m34] replaces all patterns found in each line with str or block." do
        arr = ["a100", "b200", "c300"]
        ok {arr.sed(/0/, '*')} == ["a1*0", "b2*0", "c3*0"]
        ok {arr.sed(/[a-z]/){|s| s.upcase}} == ["A100", "B200", "C300"]
      end

    end


    topic '#gsed()' do

      spec "[!9lzjv] replaces first pattern found in each line with str or block." do
        arr = ["a100", "b200", "c300"]
        ok {arr.gsed(/0/, '*')} == ["a1**", "b2**", "c3**"]
        ok {arr.gsed(/[a-z]/){|s| s.upcase}} == ["A100", "B200", "C300"]
      end

    end


    fixture :dummy_files do
      pr = proc do
        if File.directory?("_test.d")
          Dir.glob("_test.d/**/*").each {|x| File.unlink(x) if File.file?(x) }
          Dir.glob("_test.d/**/*").sort.reverse.each {|x| Dir.rmdir(x) }
          Dir.rmdir("_test.d")
        end
      end
      pr.call
      at_end(&pr)
      Dir.mkdir "_test.d"
      Dir.mkdir "_test.d/src"
      Dir.mkdir "_test.d/lib"
      File.open("_test.d/src/file1.txt", "w") {|f| f.write("file1") }
      File.open("_test.d/src/file2.txt", "w") {|f| f.write("file2") }
      nil
    end


    topic '#move_to()' do

      spec "[!n0ubo] block argument is required." do
        pr = proc { ["file1"].move_to }
        ok {pr}.raise?(ArgumentError, "move_to(): block argument required.")
      end

      spec "[!qqzqz] trims target file name." do
        |dummy_files|
        arr = ["  _test.d/src/file1.txt\n", "  _test.d/src/file2.txt\n"]
        arr.move_to {"_test.d/lib"}
        ok {"_test.d/lib/file1.txt"}.file_exist?
        ok {"_test.d/lib/file2.txt"}.file_exist?
      end

      spec "[!nnud9] destination directory name is derived from target file name." do
        |dummy_files|
        Dir.mkdir("_test.d/lib1")
        Dir.mkdir("_test.d/lib2")
        Dir.glob("_test.d/src/*.txt").move_to {|s| s =~ /file(\d+)\.\w+$/; "_test.d/lib#{$1}" }
        ok {"_test.d/lib/file1.txt"}.NOT.exist?
        ok {"_test.d/lib/file2.txt"}.NOT.exist?
        ok {"_test.d/lib1/file1.txt"}.file_exist?
        ok {"_test.d/lib2/file2.txt"}.file_exist?
      end

      spec "[!n7a1q] prints target file and destination directory when verbose mode." do
        |dummy_files|
        ret = Dir.glob("_test.d/src/*.txt").move_to {"_test.d/lib"}
        ok {ret} == [
          "Move: '_test.d/src/file1.txt' => '_test.d/lib'",
          "Move: '_test.d/src/file2.txt' => '_test.d/lib'",
        ]
      end

      spec "[!ey3e4] if target directory name is nil or empty, skip moving file." do
        |dummy_files|
        expected = [
          "Skip: target directory name is nil or empty (file: '_test.d/src/file1.txt')",
          "Skip: target directory name is nil or empty (file: '_test.d/src/file2.txt')",
        ]
        ret = Dir.glob("_test.d/src/*.txt").move_to {""}
        ok {ret} == expected
        ret = Dir.glob("_test.d/src/*.txt").move_to {nil}
        ok {ret} == expected
      end

      spec "[!i5jt6] if destination directory exists, move file to it." do
        |dummy_files|
        ret = Dir.glob("_test.d/src/*.txt").move_to {"_test.d/lib"}
        ok {"_test.d/lib/file1.txt"}.file_exist?
        ok {"_test.d/lib/file2.txt"}.file_exist?
      end

      spec "[!azqgk] if there is a file that name is same as desination directory, skip." do
        |dummy_files|
        Dir.rmdir("_test.d/lib")
        File.open("_test.d/lib", "w") {|f| f.write("x") }
        ret = Dir.glob("_test.d/src/*.txt").move_to {"_test.d/lib"}
        ok {ret} == [
          "Skip: directory '_test.d/lib' not a directory",
          "Skip: directory '_test.d/lib' not a directory",
        ]
      end

      spec "[!rqu5q] if destinatio directory doesn't exist, skip." do
        |dummy_files|
        Dir.rmdir("_test.d/lib")
        ret = Dir.glob("_test.d/src/*.txt").move_to {"_test.d/lib"}
        ok {ret} == ["Skip: directory '_test.d/lib' not exist", "Skip: directory '_test.d/lib' not exist"]
      end

    end


    topic '#mkdir_and_move_to()' do

      spec "[!k74dw] block argument is required." do
        pr = proc { ["file1"].mkdir_and_move_to }
        ok {pr}.raise?(ArgumentError, "mkdir_and_move_to(): block argument required.")
      end

      spec "[!b9d4m] if destination directory doesn't exist, creates it." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.mkdir_and_move_to {|s| s =~ /file(\d+)/; "_test.d/lib#{$1}" }
        ok {"_test.d/lib1/file1.txt"}.file_exist?
        ok {"_test.d/lib2/file2.txt"}.file_exist?
        ok {ret} == [
          "Move: '_test.d/src/file1.txt' => '_test.d/lib1'",
          "Move: '_test.d/src/file2.txt' => '_test.d/lib2'",
        ]
      end

    end


  end


end
