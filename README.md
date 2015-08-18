# gr8 README

(Release: $Release: 0.1.1 $)

gr8 (pronounce as _greight_ or _great_) is a great command-line utility powered by Ruby.
You can use gr8 instead of sed or awk.


## Installation

    $ gem install gr8

Or:

    $ curl -o gr8 http://bit.ly/gr8_rb
    $ chmod a+x gr8
    $ sudo mv gr8 /usr/local/bin

Gr8 requires Ruby (>= 2.0).


## Usage

Usage: gr8 _[options]_ ruby-code

Options:

* -h, --help        : show help
* -v, --version     : show version
* -r lib[,lib2,...] : require libraries
* -F[regexp]        : separate each line with separator
* -C N              : select column (1-origin)


## Example 1: Aggregation

Data file:

    $ cat data
    Haruhi  100
    Mikuru   80
    Yuki    120

Prints each line (`gr8` command prints expression value automatically when non-nil):

    $ cat data | gr8 '$stdin.lazy.map{|s| s }'
    Haruhi  100
    Mikuru   80
    Yuki    120

`$stdin.lazy` is omissible because `gr8` command uses it as current context (=`self`):

    $ cat data | gr8 'map{|s| s }'
    Haruhi  100
    Mikuru   80
    Yuki    120

Select second column:

    $ cat data | gr8 'map{|s| s.split()[1] }'
    100
    80
    120

`map{|s|s.split()}` can be `map{split()}` in `gr8` command
because `gr` extends `map()` and `select()` to set each item as self
in block arguments of them:

    $ cat data | gr8 'map{split()[1]}'
    100
    80
    120

Calculates total of numbers:

    $ cat data | gr8 'map{split()[1]}.map(&:to_i).inject(0,:+)'
    300

`sum()` is a short-hand for `inject(0,:+)`:

    $ cat data | gr8 'map{split()[1]}.map(&:to_i).sum'
    300

`sum_i()` is a short-hand for `map(&:to_i).inject(0,:+)`:

    $ cat data | gr8 'map{split()[1]}.sum_i'   # or 'sum_f' for float
    300

Command-line opiton '-F' splits each line into array:

    $ cat data | gr8 -F 'map{self.inspect}'
    ["Haruhi", "100"]
    ["Mikuru", "80"]
    ["Yuki", "120"]
    $ cat data | gr8 -F 'map{self[1]}.sum_i'   # or 'map{|a|a[1]}.sum_i'
    300

Command-line option '-C n' selects column (1-origin):

    $ cat data | gr8 -C 2 'map{self}'
    100
    80
    120
    $ cat data | gr8 -C 2 'sum_i'
    300

Calculates average of numbers instead of total:

    $ cat data | gr8 -C 2 'map(&:to_i).avg'
    300.0
    $ cat data | gr8 -C 2 'avg_i'
    300.0

Compared to `ruby -ne`:

    $ cat data | ruby -ne 'BEGIN{t=0};t+=$_.split[1].to_i;END{p t}'
    300
    $ cat data | ruby -ane 'BEGIN{t=0};t+=$F[1].to_i;END{p t}'
    300


## Example 2: Generating Shell Commands

Assume that there are some image files:

    $ ls
    img1.jpg      img2.jpg      img3.jpg
    img4.png      img5.png      img6.png

Select PNG files:

    $ ls | gr8 'grep(/(.*)\.png$/)'
    img1.png
    img2.png
    img3.png

Prints new filename replacing '.png' with '.jpg':

    $ ls | gr8 'grep(/(.*)\.png/) { "#{$1}.jpg" }'
    img1.jpg
    img2.jpg
    img3.jpg

Prints OS command to convert PNG file into JPG:

    $ ls | gr8 'grep(/(.*)\.png/) { "convert #{$1}.png #{$1}.jpg" }'
    convert img1.png img1.jpg
    convert img2.png img2.jpg
    convert img3.png img3.jpg

You may want quotes file name with single quotation:

    $ ls | gr8 'grep(/(.*)\.png/) { "convert #{$1.q}.png #{$1.q}.jpg" }'
    convert 'img1'.png 'img1'.jpg
    convert 'img2'.png 'img2'.jpg
    convert 'img3'.png 'img3'.jpg

Or double quotation:

    $ ls | gr8 'grep(/(.*)\.png/) { "convert #{$1.qq}.png #{$1.qq}.jpg" }'
    convert "img1".png "img1".jpg
    convert "img2".png "img2".jpg
    convert "img3".png "img3".jpg

Run os commands after you confirmed them:

    $ ls | gr8 'grep(/(.*)\.png/){"convert #{$1.q}.png #{$1.q}.jpg"}' | sh


## Example 3: File Manipulation

`Kernel#fu()` is a short-hand which returns `FileUtil` module.
Using it, You can rename or move files very easily.

Assume that there are several PNG files:

    $ ls | gr8 'grep(/^a(\d+)/)'
    a1.png
    a2.png
    a3.png

And you want to rename them to other names:

    $ ls | gr8 'grep(/^a(\d+)/) { "b#{$1.to_i+100}.png" }'
    b101.png
    b102.png
    b103.png

`fu.mv` is a short-hand to `require "fileutils"; FileUtils.mv`:

    $ ls | gr8 'grep(/^a(\d+)/){fu.mv "a#{$1}.png", "b#{$1.to_i+100}.png"}'
    $ ls b*.png
    b101.png   b102.png   b103.png     # renamed from 'a1.png', 'a2.png' and 'a3.png'

(Experimental)

`gr8` provides more convenient methods to mapipulate files:

    $ ls | gr8 'copy_as    { sub(/\.htm$/, ".html") }'
    $ ls | gr8 'copy_as!   { sub(/\.htm$/, ".html") }'  # overwrite existing file
    $ ls | gr8 'rename_as  { sub(/\.htm$/, ".html") }'
    $ ls | gr8 'rename_as! { sub(/\.htm$/, ".html") }'  # overwrite existing file
    $ ls | gr8 'copy_to  { "some/where/directory/" }'
    $ ls | gr8 'copy_to! { "some/where/directory/" }'   # overwrite existing file
    $ ls | gr8 'move_to  { "some/where/directory/" }'
    $ ls | gr8 'move_to! { "some/where/directory/" }'   # overwrite existing file


## References


### Kernel#fu()

Returns `FileUtils` class object.

Example:

    $ ls | gr8 'grep(/(.*)\.png/){fu.mv "#{$1}.png", "#{$1}.jpg"}'


### String#q(), #qq()

`q()` quotes string with single-quotation, with escaping singile-quotation with backslash.

`qq()` quotes string with double-quotation, with escaping singile-quotation with backslash.

These are convenient when file name contains spaces.

Example:

    $ echo 'Image 1.png' | gr8 'grep(/(.*)\.png/){"convert #{$1.q}.png #{$1.q}.jpg"}'
    convert 'Image 1'.png 'Image 1'.jpg
    $ ls | gr8 'grep(/(.*)\.png/){"convert #{$1.qq}.png #{$1.qq}.jpg"}'
    convert "Image 1".png "Image 1".jpg


### Enumerable#transform(){...}, #xf(){...}

Similar to `map()`, but it sets each item as self in block argument.

Example:

    $ ls *.png | gr8 'xf{self}'
    A.png
    B.png
    C.png
    $ ls *.png | gr8 'xf{sub(/\.png/, '.jpg')}'
    A.jpg
    B.jpg
    C.jpg

Source code:

    def transform(&block)
      collect {|x| x.instance_exec(x, &block) }
    end
    alias xf transform


### Enumerable#map(){...}

Extended to set each item as self in block argument of `map()`.
If you want original `map()`, use `collect()` instead.

Example:

    $ ls *.png | gr8 'map{self}'
    A.png
    B.png
    C.png
    $ ls *.png | gr8 'map{sub(/\.png/, '.jpg')}'
    A.jpg
    B.jpg
    C.jpg

Source code:

    alias __map map
    def map(&block)
      __map {|x| x.instance_exec(x, &block) }
    end


### Enumerable#select(){...}

Extended to set each item as self in block argument of `select()`.
If you want original `select()`, use `find_all()` instead.

Example:

    $ ls *.png | gr8 'select{self}'
    A.png
    B.png
    C.png
    $ ls *.png | gr8 'select{start_with?("B")}'
    B.jpg

Source code:

  alias __select select
  def select(&block)
    __select {|x| x.instance_exec(x, &block) }
  end


### Enumerable#sum()

Same as `inject(0, :+)`.

Example:

    $ cat file
    10.5
    20.5
    30.5
    $ cat file | gr8 'map(&:to_f).sum'
    61.5


### Enumerable#sum_i(), #sum_f()

Same as `map(&:to_i).inject(0, :+)` or `map(&:to_f).inject(0, :+)`

Example:

    $ cat file
    10.5
    20.5
    30.5
    $ cat file | gr8 'sum_i'
    60
    $ cat file | gr8 'sum_f'
    61.5


### Enumerable#avg()

Returns average of numbers.

Example:

    $ cat file
    10.1
    20.2
    30.3
    $ cat data |gr8 'map(&:to_i).avg'
    20.0


### Enumerable#avg_i(), #avg_f()

Same as `map(&:to_i).avg` or `map(&:to_f).avg`.

Example:

    $ cat file
    10.1
    20.2
    30.3
    $ cat data |gr8 'avg_i'
    20.0
    $ cat data |gr8 'avg_f'
    20.2


### Enumerable#sed(pattern, replacing), #sed(pattern){...}

Replaces the first pattern in each line with replacing string or block.
Internally, `sed()` calls `String#sub()`.

Example:

    $ ls *.png
    A.png
    B.png
    C.png
    $ ls *.png | gr8 'sed(/png/, "jpg")'
    A.png
    B.png
    C.png

Source code:

    def sed(pat, str=nil, &block)
      if block_given?
        collect {|s| s.sub(pat, &block) }
      else
        collect {|s| s.sub(pat, str) }
      end
    end


### Enumerable#gsed(pattern, replacing), #gsed(pattern){...}

Replaces all of pattern in each line with replacing string or block.
Internally, `gsed()` calls `String#gsub()`.

Example:

    $ ls *.png
    A1-1.png
    A1-2.png
    A1-3.png
    $ ls *.png | gr8 'sed(/\d+/, "00\\&")'
    A001-1.png
    A001-2.png
    A001-3.png
    $ ls *.png | gr8 'gsed(/\d+/, "00\\&")'
    A001-001.png
    A001-002.png
    A001-003.png

Source code:

    def gsed(pat, str=nil, &block)
      if block_given?
        collect {|s| s.gsub(pat, &block) }
      else
        collect {|s| s.gsub(pat, str) }
      end
    end


### Enumerable#paths(), #paths{...}

Converts each item into `Pathname` object.
Library `pathname` will be loaded automatically.

Example:

    $ /bin/ls | gr8 'paths{|x| "#{x}: #{x.ftype}"}'
    MIT-LICENSE: file
    README.txt: file
    Rakefile: file
    bin: directory
    lib: directory
    test: directory

Source code:

  def paths(&block)
    require "pathname" unless defined?(Pathname)
    if block_given?
      collect {|s| x = Pathname(s); x.instance_exec(x, &block) }
    else
      collect {|s| Pathname(s) }
    end
  end


### Enumerable#edit(verbose=true, encodint='utf-8'){|content, filepath| ...}

Replace file content with result of block argument.

Example:

    $ ls *.rb | gr8 'edit{|s|
      s = s.gsub(/Release: \d+\.\d+\.\d+/, "Release: 1.2.3")
      s = s.gsub(/Copyright: \d+-\d+/, "Copyright: 2013-2015")
      s }'


### Enumerable#edit_i(suffix, verbose=true, encodint='utf-8'){|content, filepath| ...}

Copy backup file with suffix before editing file.

Example:

    $ ls *.rb
    hom.rb    mad.rb
    $ ls *.rb | gr8 'edit_i(".bkup"){|s|
      s = s.gsub(/Release: \d+\.\d+\.\d+/, "Release: 1.2.3")
      s = s.gsub(/Copyright: \d+-\d+/, "Copyright: 2013-2015")
      s }'
    $ ls *.bkup
    hom.rb    hom.rb.bkup     mad.rb     mad.rb.bkup


### Enumerable#copy_to{...}, #copy_to!{...}

(Experimental)

Copy files into destination directory, without renaming basename.

* Block argument should return destination directory name.
* `copy_to()` skips when destination file already exists.
* `copy_to!()` overwrites when destination file already exists.
* Both skips copying when destination directory doesn't exist.


### Enumerable#mkdir_and_copy_to{...}, #mkdir_and_copy_to!{...}

(Experimental)

Similar to `copy_to()` or `copy_to!()` except creating destination directory when not exist.


### Enumerable#move_to{...}, #move_to!{...}

(Experimental)

Move files into destination directory, without renaming basename.

* Block argument should return destination directory name.
* `move_to()` skips when destination file already exists.
* `move_to!()` overwrites when destination file already exists.
* Both skips moving files when destination directory doesn't exist.


### Enumerable#mkdir_and_move_to{...}, #mkdir_and_move_to!{...}

(Experimental)

Similar to `move_to()` or `move_to!()` except creating destination directory when not exist.


### Enumerable#copy_as{...}, #copy_as!{...}

(Experimental)

Copy files into destination directory, with renaming basename.

* Block argument should return destination file name.
* `copy_as()` skips when destination file already exists.
* `copy_as!()` overwrites when destination file already exists.
* Both skips copying when destination directory doesn't exist.


### Enumerable#mkdir_and_copy_as{...}, #mkdir_and_copy_as!{...}

(Experimental)

Similar to `copy_as()` or `copy_as!()` except creating destination directory when not exist.


### Enumerable#rename_as{...}, #rename_as!{...}

(Experimental)

Move files into destination directory, with renaming basename.

* Block argument should return destination file name.
* `rename_as()` skips when destination file already exists.
* `rename_as!()` overwrites when destination file already exists.
* Both skips moving when destination directory doesn't exist.


### Enumerable#mkdir_and_rename_as{...}, #mkdir_and_rename_as!{...}

(Experimental)

Similar to `rename_as()` or `rename_as!()` except creating destination directory when not exist.


## License and Copyright

$License: MIT License $

$Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
