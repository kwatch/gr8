# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

$: << File.dirname(__FILE__)

require "oktest"
require "stringio"

load File.class_eval { join(dirname(dirname(__FILE__)), "bin", "gr8") }


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

      spec "[!zcxh1] removes '\n' from each line automatically." do
        |app, input_data|
        expected = <<'END'
"Haruhi  100"
"Mikuru   80"
"Yuki    120"
END
        code = "map{|s| s.inspect }"
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == expected
      end

      spec "[!i7npb] $1, $2, ... are available in grep() block argument." do
        |app, input_data|
        code = 'grep(/^(\w+)\s+(\d+)$/){$1}'
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == "Haruhi\nMikuru\nYuki\n"
        #
        code = 'grep(/^(\w+)\s+(\d+)$/){$2.to_i}.inject(0,:+)'
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == "300\n"
      end

      spec "[!vkt64] lines are chomped automatically in grep() if block is not given." do
        |app, input_data|
        code = 'grep(/\d+/).map{|s| s.inspect}'
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == <<'END'
"Haruhi  100"
"Mikuru   80"
"Yuki    120"
END
      end

      spec "[!zfmcx] each item is available as self in block of map()." do
        |app, input_data|
        code = 'map{self.inspect}'
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == <<'END'
"Haruhi  100"
"Mikuru   80"
"Yuki    120"
END
        #
        code = 'map{split[1]}'
        sout, _ = dummy_io(input_data) { app.run(code) }
        ok {sout} == "100\n80\n120\n"
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
