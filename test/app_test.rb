# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require_relative "common"
require "oktest"


Oktest.scope do


  topic Gr8::App do

    fixture :app do
      app = Gr8::App.new
      app.instance_variable_set('@script_name', "gr8")
      app
    end

    fixture :input_data do
      <<END
Haruhi  100
Mikuru   80
Yuki    120
END
    end


    topic '#run()' do

      spec "[!33bj3] prints help message when '-h' or '--help' specified." do
        |app|
        expected = Gr8::HELP % {script: "gr8"}
        #
        status = nil
        sout, serr = dummy_io { status = app.run("-h") }
        ok {sout} == expected
        ok {serr} == ""
        ok {status} == 0
        #
        status = nil
        sout, serr = dummy_io { status = app.run("--help") }
        ok {sout} == expected
        ok {serr} == ""
        ok {status} == 0
      end

      spec "[!2tfh5] prints version string when '-v' or '--version' specified." do
        |app|
        expected = Gr8::VERSION + "\n"
        #
        status = nil
        sout, serr = dummy_io { status = app.run("-v") }
        ok {sout} == expected
        ok {serr} == ""
        ok {status} == 0
        #
        status = nil
        sout, serr = dummy_io { status = app.run("--version") }
        ok {sout} == expected
        ok {serr} == ""
        ok {status} == 0
      end

      spec "[!1s7wm] requires libraries when '-r' or '--require' specified." do
        |app|
        ok {defined?(PStore)}     == nil
        ok {defined?(GetoptLong)} == nil
        dummy_io { app.run("-r pstore,getoptlong", "map{|s| s}") }
        ok {defined?(PStore)}     == "constant"
        ok {defined?(GetoptLong)} == "constant"
      end

      spec "[!7wqyh] prints error when no argument." do
        |app|
        status = nil
        sout, serr = dummy_io { status = app.run() }
        ok {sout} == ""
        ok {serr} == "ERROR (gr8): argument required.\n"
        ok {status} == 1
      end

      spec "[!bwiqv] prints error when too many argument." do
        |app|
        status = nil
        sout, serr = dummy_io { status = app.run("a", "b") }
        ok {sout} == ""
        ok {serr} == "ERROR (gr8): too many arguments.\n"
        ok {status} == 1
      end

      spec "[!r69d6] executes ruby code with $stdin.lazy as self." do
        |app, input_data|
        code = "map{|s| s.split()[1].to_i}.inject(0,:+)"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run(code) }
        ok {sout} == "300\n"
        ok {serr} == ""
        ok {status} == 0
        #
        code = "self.is_a?(Enumerator::Lazy)"
        sout, serr = dummy_io(input_data) { app.run(code) }
        ok {sout} == "true\n"
      end

      spec "[!8hk3g] option '-F': separates each line into array." do
        |app|
        input_data = "A:10:x\n" + "B:20:y\n" + "C:30:z\n"
        code = "map{|s| s.inspect }"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run("-F:", code) }
        ok {sout} == %Q`["A", "10", "x"]\n["B", "20", "y"]\n["C", "30", "z"]\n`
        ok {serr} == ""
        ok {status} == 0
      end

      spec "[!jt4y5] option '-F': separator is omissible." do
        |app, input_data|
        code = "map{|s| s.inspect }"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run("-F", code) }
        ok {sout} == %Q`["Haruhi", "100"]\n["Mikuru", "80"]\n["Yuki", "120"]\n`
        ok {serr} == ""
        ok {status} == 0
      end

      spec "[!jo4gm] option '-F': error when invalid regular expression." do
        |app, input_data|
        code = "map{|s| s.inspect }"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run("-F[a-}", code) }
        ok {sout} == ""
        ok {serr} == "#ERROR (gr8): invalid regular expression: -F[a-}\n"
        ok {status} == 1
      end

      spec "[!vnwu6] option '-C': select colum." do
        |app, input_data|
        code = "map{|s| s.inspect }"
        sout, serr = dummy_io(input_data) { app.run("-C2", code) }
        ok {sout} == %Q`"100"\n"80"\n"120"\n`
        ok {serr} == ""
      end

      spec "[!7ruq0] option -C: argument should be an integer." do
        |app, input_data|
        code = "map{|s| s.inspect }"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run("-Cx", code) }
        ok {sout} == ""
        ok {serr} == "#ERROR (gr8): integer expected: -Cx\n"
        ok {status} == 1
      end

      spec "[!6x3dp] option -C: argument should be >= 1." do
        |app, input_data|
        code = "map{|s| s.inspect }"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run("-C0", code) }
        ok {sout} == ""
        ok {serr} == "#ERROR (gr8): column number should be >= 1: -C0\n"
        ok {status} == 1
      end

      spec "[!hsvnd] prints nothing when result is nil." do
        |app, input_data|
        sout, serr = dummy_io(input_data) { app.run("nil") }
        ok {sout} == ""
        ok {serr} == ""
      end

      spec "[!eiaa6] prints each item when result is Enumerable." do
        |app, input_data|
        sout, serr = dummy_io(input_data) { app.run("[10, 20, 30]") }
        ok {sout} == "10\n20\n30\n"
        ok {serr} == ""
      end

      spec "[!6pfay] prints value when result is not nil nor Enumerable." do
        |app, input_data|
        sout, serr = dummy_io(input_data) { app.run("123") }
        ok {sout} == "123\n"
        ok {serr} == ""
      end

      spec "[!h5wln] returns 0 as status code when executed successfully." do
        |app, input_data|
        code = "map{|s| s.split[1]}.map(&:to_i).inject(0,:+)"
        status = nil
        sout, serr = dummy_io(input_data) { status = app.run(code) }
        ok {status} == 0
        ok {sout} == "300\n"
        ok {serr} == ""
      end

    end


    topic '#main()' do

      spec "[!w9kb8] exit with status code 0 when executed successfully." do
        |app|
        skip_when true, "contains exit()"
      end

      spec "[!nbag1] exit with status code 1 when execution failed." do
        |app|
        skip_when true, "contains exit()"
      end

    end


    topic '#parse_options()' do

      spec "[!5efp5] returns Hash object containing command-line options." do
        args = ["-h", "--version", "arg1", "arg2"]
        opts = Gr8::App.new.__send__(:parse_options, args)
        ok {opts}.is_a?(Hash)
        ok {opts} == {help: true, version: true}
      end

      spec "[!wdzss] modifies args." do
        args = ["-h", "--version", "arg1", "arg2"]
        opts = Gr8::App.new.__send__(:parse_options, args)
        ok {args} == ["arg1", "arg2"]
      end

    end


  end


end
