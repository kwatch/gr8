# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require_relative "common"
require "oktest"


Oktest.scope do


  topic Enumerable do


    topic '#transform()' do

      spec "[!peitw] similar to map() or collect(), make each item as self in block." do
        ok { (1..3).xf {|i| i*10 }    } == [10, 20, 30]
        ok { (1..3).xf {|i| self*10 } } == [10, 20, 30]
      end

    end


    topic '#map()' do

      spec "[!zfmcx] each item is available as self in block of map()." do
        ok { (1..3).map {|i| i * 10}  } == [10, 20, 30]
        ok { (1..3).map {|i| self*10} } == [10, 20, 30]
      end

    end


    topic '#select()' do

      spec "[!41hap] each item is available as self in block of select()." do
        ok { (1..5).select {|i| i % 2    == 0 } } == [2, 4]
        ok { (1..5).select {|i| self % 2 == 0 } } == [2, 4]
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


    topic '#paths()' do

      spec "[!t55ce] collects Pathname objects when block argument is not passed." do
        arr = ["A.txt", "B.txt", "C.txt"]
        ok {arr.paths}.all? {|x| x.is_a?(Pathname) }
      end

      spec "[!yjkm5] yields Pathname objects when block argument is passed." do
        arr = ["A.txt", "B.txt", "C.txt"]
        ok {arr.paths{|x| x.exist?}} == [false, false, false]
      end

      spec "[!4kppy] self is Patname object in block argument." do
        arr = ["A.txt", "B.txt", "C.txt"]
        ok {arr.paths{self.is_a?(Pathname)}}.all? {|x| x == true }
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

    def _write_file(filepath, content)
      File.open(filepath, "w") {|f| f.write(content) }
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

      spec "[!0gq9h] if destination file already exist, skip." do
        |dummy_files|
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = Dir.glob("_test.d/src/*.txt").move_to {"_test.d/lib"}
        ok {ret} == [
          "Skip: destination file '_test.d/lib/file1.txt' already exist.",
          "Skip: destination file '_test.d/lib/file2.txt' already exist.",
        ]
        ok {File.read("_test.d/lib/file1.txt")} == "xxx"   # not overwritten
        ok {File.read("_test.d/lib/file2.txt")} == "yyy"   # not overwrirten
      end

    end


    topic '#move_to!()' do

      spec "[!40se5] block argument is required." do
        pr = proc { ["file1"].move_to! }
        ok {pr}.raise?(ArgumentError, "move_to!(): block argument required.")
      end

      spec "[!ebdqh] overwrite destination file even if it exists." do
        |dummy_files|
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = Dir.glob("_test.d/src/*.txt").move_to! {"_test.d/lib"}
        ok {ret} == [
          "Move!: '_test.d/src/file1.txt' => '_test.d/lib'",
          "Move!: '_test.d/src/file2.txt' => '_test.d/lib'",
        ]
        ok {File.read("_test.d/lib/file1.txt")} == "file1"   # overwritten
        ok {File.read("_test.d/lib/file2.txt")} == "file2"   # overwrirten
      end

      spec "[!itsh0] use 'Move!' instead of 'Move' when overwriting existing file." do
        |dummy_files|
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = Dir.glob("_test.d/src/*.txt").move_to! {"_test.d/lib"}
        ok {ret} == [
          "Move!: '_test.d/src/file1.txt' => '_test.d/lib'",
          "Move!: '_test.d/src/file2.txt' => '_test.d/lib'",
        ]
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


    topic '#mkdir_and_move_to!()' do

      spec "[!z9yus] block argument is required." do
        pr = proc { ["file1"].mkdir_and_move_to! }
        ok {pr}.raise?(ArgumentError, "mkdir_and_move_to!(): block argument required.")
      end

    end


    topic '#rename_as()' do

      spec "[!ignfm] block argument is required." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        pr = proc {files.rename_as("_test.d/lib/file.txt")}
        ok {pr}.raise?(ArgumentError, "rename_as(): block argument required.")
      end

      spec "[!qqzqz] trims target file name." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt").map {|s| " #{s}\n"}
        files.rename_as{sub(/src/, 'lib')}
        ok {"_test.d/src/file1.txt"}.NOT.exist?
        ok {"_test.d/src/file2.txt"}.NOT.exist?
        ok {"_test.d/lib/file1.txt"}.file_exist?
        ok {"_test.d/lib/file2.txt"}.file_exist?
      end

      spec "[!nnud9] destination file name is derived from source file name." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        files.rename_as{sub(/\.txt$/, '.tmp')}
        ok {"_test.d/src/file1.txt"}.NOT.exist?
        ok {"_test.d/src/file2.txt"}.NOT.exist?
        ok {"_test.d/src/file1.tmp"}.file_exist?
        ok {"_test.d/src/file2.tmp"}.file_exist?
      end

      spec "[!dkejf] if target directory name is nil or empty, skips renaming file." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.rename_as{nil}
        ok {ret} == [
          "Skip: target file name is nil or empty (file: '_test.d/src/file1.txt')",
          "Skip: target file name is nil or empty (file: '_test.d/src/file2.txt')",
        ]
        ok {"_test.d/src/file1.txt"}.file_exist?
        ok {"_test.d/src/file2.txt"}.file_exist?
        #
        ret = files.rename_as{""}
        ok {ret} == [
          "Skip: target file name is nil or empty (file: '_test.d/src/file1.txt')",
          "Skip: target file name is nil or empty (file: '_test.d/src/file2.txt')",
        ]
        ok {"_test.d/src/file1.txt"}.file_exist?
        ok {"_test.d/src/file2.txt"}.file_exist?
      end

      spec "[!8ap57] if target file or directory already exists, skips renaming files." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = files.rename_as {sub(/src/, 'lib')}
        ok {ret} == [
          "Skip: target file '_test.d/lib/file1.txt' already exists.",
          "Skip: target file '_test.d/lib/file2.txt' already exists.",
        ]
        ok {"_test.d/src/file1.txt"}.file_exist?
        ok {"_test.d/src/file2.txt"}.file_exist?
        ok {"_test.d/lib/file1.txt"}.file_exist?
        ok {"_test.d/lib/file2.txt"}.file_exist?
      end

      spec "[!qhlc8] if directory of target file already exists, renames file." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.rename_as {sub(/src/, 'lib').sub(/\.txt/, '.tmp')}
        ok {ret} == [
          "Rename: '_test.d/src/file1.txt' => '_test.d/lib/file1.tmp'",
          "Rename: '_test.d/src/file2.txt' => '_test.d/lib/file2.tmp'",
        ]
        ok {"_test.d/src/file1.txt"}.NOT.exist?
        ok {"_test.d/src/file2.txt"}.NOT.exist?
        ok {"_test.d/lib/file1.tmp"}.file_exist?
        ok {"_test.d/lib/file2.tmp"}.file_exist?
      end

      spec "[!gg9w1] if directory of target file not exist, skips renaming files." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.rename_as {sub(/src/, 'var')}
        ok {ret} == [
          "Skip: directory of target file '_test.d/var/file1.txt' not exist.",
          "Skip: directory of target file '_test.d/var/file2.txt' not exist.",
        ]
        ok {"_test.d/src/file1.txt"}.file_exist?
        ok {"_test.d/src/file2.txt"}.file_exist?
        ok {"_test.d/var/file1.txt"}.NOT.exist?
        ok {"_test.d/var/file2.txt"}.NOT.exist?
      end

      spec "[!vt24y] prints target file and destination directory when verbose mode." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.rename_as {sub(/src/, 'lib').sub(/.txt/, '.tmp')}
        ok {ret} == [
          "Rename: '_test.d/src/file1.txt' => '_test.d/lib/file1.tmp'",
          "Rename: '_test.d/src/file2.txt' => '_test.d/lib/file2.tmp'",
        ]
      end

    end


    topic '#rename_as!()' do

      spec "[!ignfm] block argument is required." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        pr = proc {files.rename_as!("_test.d/lib/file.txt")}
        ok {pr}.raise?(ArgumentError, "rename_as!(): block argument required.")
      end

      spec "[!qqzqz] trims target file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!nnud9] destination file name is derived from source file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!dkejf] if target directory name is nil or empty, skips renaming file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!1yzjd] if target file or directory already exists, removes it before renaming file." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = files.rename_as! {sub(/src/, 'lib')}
        ok {ret} == [
          "Rename!: '_test.d/src/file1.txt' => '_test.d/lib/file1.txt'",
          "Rename!: '_test.d/src/file2.txt' => '_test.d/lib/file2.txt'",
        ]
        ok {"_test.d/src/file1.txt"}.NOT.exist?
        ok {"_test.d/src/file2.txt"}.NOT.exist?
        ok {"_test.d/lib/file1.txt"}.file_exist?
        ok {"_test.d/lib/file2.txt"}.file_exist?
      end

      spec "[!qhlc8] if directory of target file already exists, renames file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!gg9w1] if directory of target file not exist, skips renaming files." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!vt24y] prints target file and destination directory when verbose mode." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!gd9j9] use 'Rename!' instead of 'Rename' when overwriting existing file." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        _write_file("_test.d/lib/file1.txt", "xxx")
        _write_file("_test.d/lib/file2.txt", "yyy")
        ret = files.rename_as! {sub(/src/, 'lib')}
        ok {ret} == [
          "Rename!: '_test.d/src/file1.txt' => '_test.d/lib/file1.txt'",
          "Rename!: '_test.d/src/file2.txt' => '_test.d/lib/file2.txt'",
        ]
      end

    end


    topic '#mkdir_and_rename_as()' do

      spec "[!ignfm] block argument is required." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        pr = proc {files.mkdir_and_rename_as("_test.d/lib/file.txt")}
        ok {pr}.raise?(ArgumentError, "mkdir_and_rename_as(): block argument required.")
      end

      spec "[!qqzqz] trims target file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!nnud9] destination file name is derived from source file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!dkejf] if target directory name is nil or empty, skips renaming file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!8ap57] if target file or directory already exists, skips renaming files." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!qhlc8] if directory of target file already exists, renames file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!sh2ti] if directory of target file not exist, creates it." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.mkdir_and_rename_as {sub(/src/, 'var/tmp').sub(/\.txt/, '.tmp')}
        ok {ret} == [
          "Rename: '_test.d/src/file1.txt' => '_test.d/var/tmp/file1.tmp'",
          "Rename: '_test.d/src/file2.txt' => '_test.d/var/tmp/file2.tmp'",
        ]
        ok {"_test.d/src/file1.txt"}.NOT.exist?
        ok {"_test.d/src/file2.txt"}.NOT.exist?
        ok {"_test.d/var/tmp/file1.tmp"}.file_exist?
        ok {"_test.d/var/tmp/file2.tmp"}.file_exist?
      end

      spec "[!vt24y] prints source and destination file path when verbose mode." do
        skip_when true, "(common to rename_as())"
      end

    end


    topic '#mkdir_and_rename_as!()' do

      spec "[!ignfm] block argument is required." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        pr = proc {files.mkdir_and_rename_as!("_test.d/lib/file.txt")}
        ok {pr}.raise?(ArgumentError, "mkdir_and_rename_as!(): block argument required.")
      end

      spec "[!qqzqz] trims target file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!nnud9] destination file name is derived from source file name." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!dkejf] if target directory name is nil or empty, skips renaming file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!1yzjd] if target file or directory already exists, removes it before renaming file." do
        skip_when true, "(common to rename_as!())"
      end

      spec "[!qhlc8] if directory of target file already exists, renames file." do
        skip_when true, "(common to rename_as())"
      end

      spec "[!sh2ti] if directory of target file not exist, creates it." do
        skip_when true, "(common to mkdir_and_rename_as())"
      end

      spec "[!vt24y] prints source and destination file path when verbose mode." do
        skip_when true, "(common to rename_as())"
      end

    end


    topic '#copy_as()' do

      spec "[!0txp4] copy files or directories." do
        |dummy_files|
        files = Dir.glob("_test.d/src/*.txt")
        ret = files.copy_as { sub(/src/, 'lib').sub(/\.txt$/, '.tmp') }
        ok {ret} == [
          "Copy: '_test.d/src/file1.txt' => '_test.d/lib/file1.tmp'",
          "Copy: '_test.d/src/file2.txt' => '_test.d/lib/file2.tmp'",
        ]
        ok {"_test.d/src/file1.txt"}.file_exist?
        ok {"_test.d/src/file2.txt"}.file_exist?
        ok {"_test.d/lib/file1.tmp"}.file_exist?
        ok {"_test.d/lib/file2.tmp"}.file_exist?
      end

    end


    topic '#copy_as!()' do

    end


    topic '#mkdir_and_copy_as()' do

    end


    topic '#mkdir_and_copy_as!()' do

    end


  end


  topic Enumerator::Lazy do


    topic '#map()' do

      spec "[!drgky] each item is available as self in block of map()." do
        ok { (1..3).lazy.map {|i| i * 10 } }.is_a?(Enumerator::Lazy)
        ok { (1..3).lazy.map {|i| i * 10 }.to_a } == [10, 20, 30]
        ok { (1..3).lazy.map {|i| self*10}.to_a } == [10, 20, 30]
      end

    end


    topic '#select()' do

      spec "[!uhqz2] each item is available as self in block of map()." do
        ok { (1..5).lazy.select {|i| i % 2    == 0 } }.is_a?(Enumerator::Lazy)
        ok { (1..5).lazy.select {|i| i % 2    == 0 }.to_a } == [2, 4]
        ok { (1..5).lazy.select {|i| self % 2 == 0 }.to_a } == [2, 4]
      end

    end


  end


end
