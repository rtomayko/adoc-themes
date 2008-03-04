require 'rake/clean'

THEMES =  FileList['src/*.css'].
            reject { |f| f =~ /-(manpage|quirks)\.css/ }.
            map { |f| File.basename(f).sub(/\.css$/, '') }.
            uniq

task 'default' => 'all'

task 'all' => [ 'stylesheets', 'examples' ]

desc 'Build all examples'
task 'examples'

desc 'Build CSS for all themes'
task 'stylesheets'

desc 'Build documentation website'
task 'doc'

# ---------------------------------------------------------------------------
# Theme CSS Generation
# ---------------------------------------------------------------------------

FileList['src/*.css'].each do |srcfile|
  basename = File.basename(srcfile)
  destfile = "stylesheets/#{basename}"
  prereqs = (File.read(srcfile, 1024) || '').
              split("\n").
              grep(/@import/).
              map { |line| line.match(/@import\s+url\((.*)\)\s*;/)[1] }.
              map { |file| "stylesheets/#{file}" }
  file destfile => [srcfile, *prereqs] do |f|
    doing :css, f.name
    src = File.read(srcfile)
    src.gsub!(/@import\s+url\((.*)\)\s*;/) do |match|
      [
        "/* BEG #{match} */",
        File.read("stylesheets/#{$1}"),
        "/* END #{match} */"
      ].join("\n")
    end
    mkdir_p 'stylesheets'
    File.open(destfile, 'wb') { |io| io.write(src) }
    # set modified time to the oldest of all prerequisites
    mtime = f.prerequisites.map { |fn| File.mtime(fn) }.max
    File.utime(Time.now, mtime, destfile)
  end
  CLOBBER.include destfile
  task 'stylesheets' => destfile
end

# ---------------------------------------------------------------------------
# Examples
# ---------------------------------------------------------------------------

EX_MAN_SRCS = %w[examples/asciidoc.1.txt]
EX_ART_SRCS = %w[examples/userguide.txt examples/README.txt]
EX_SRCS = EX_MAN_SRCS + EX_ART_SRCS

EX_CONF = FileList['examples/*.conf']
EX_HTML = EX_SRCS.map { |f| f.sub(/\.txt/, '.html') }

file 'examples/README.txt' => 'README.txt' do |f|
  text = File.read('README.txt')
  text.gsub! /link:\.\/examples/, 'link:.'
  File.open(f.name, 'wb') { |io| io.write(text) }
end

EX_ART_SRCS.each do |srcfile|
  THEMES.each do |theme|
    prereqs = FileList[
      srcfile,
      'examples/xhtml11-article.conf',
      'examples/asciidoc.conf',
      "src/#{theme}.css"
    ]
    destfile = srcfile.
      sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc srcfile, destfile, :theme => theme,
        :stylesdir => '../src',
        :iconsdir => '../images/icons'
    end
    CLEAN.include destfile
    task "examples:#{theme}" => destfile
  end
end

EX_MAN_SRCS.each do |srcfile|
  THEMES.each do |theme|
    prereqs = FileList[
      srcfile,
      'examples/xhtml11-manpage.conf',
      'examples/asciidoc.conf',
      "src/#{theme}.css",
      "src/#{theme}-manpage.css"
    ]
    destfile = srcfile.
      sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc srcfile, destfile, '-d', 'manpage',
        :theme => theme,
        :stylesdir => '../src'
    end
    CLEAN.include destfile
    task "examples:#{theme}" => destfile
  end
end

THEMES.each do |theme|
  desc "Build #{theme} examples"
  task "examples:#{theme}"
  task 'examples' => "examples:#{theme}"
end

# ---------------------------------------------------------------------------
# Project Documentation
# ---------------------------------------------------------------------------

directory 'images'

file 'images/icons' => %w[images] do |f|
  rm_rf f.name
  asciidoc_config =
    %w[/etc/asciidoc /usr/local/etc/asciidoc /opt/local/etc/asciidoc].
      detect { |dir| File.directory?(dir) }
  if asciidoc_config
    mkdir_p 'images'
    doing 'ICONS', "images/icons (from #{asciidoc_config}/images/icons)"
    cp_r "#{asciidoc_config}/images/icons", f.name, :preserve => true
  else
    STDERR.puts "warn: cannot copy asciidoc icons" +
      "(couldn't find AsciiDoc's config directory.)"
      mkdir_p f.name
  end
end
task 'doc' => 'images/icons'
CLOBBER.include 'images/icons'

file 'README.html' => %w[README.txt stylesheets examples] do |f|
  asciidoc 'README.txt', f.name,
    :stylesdir => 'stylesheets',
    :theme => 'bare',
    :linkcss => '!'
end
task 'doc' => 'README.html'
CLOBBER.include 'README.html'

# ---------------------------------------------------------------------------
# Misc Environment Configuration and Helpers
# ---------------------------------------------------------------------------

# Disable verbose output by default. Invoke like this to turn on:
# $ rake V=1 task ...
# ... or ...
# $ rake verbose task ...
task('verbose') { verbose(true) }
verbose(ENV['V'] == '1')

# Give a status of what's going on (only when not in verbose mode). The
# message looks like:
#
#   WHAT message ...
def doing(what, message=nil)
  unless verbose
    message = [ "  #{what.to_s.upcase}", message ].compact.join(' ')
    STDERR.puts message
  end
end

# Run asciidoc with some default options and attributes.
def asciidoc(src, target, *args)
  attributes =
    if args.last.is_a?(Hash)
      args.pop
    else
      {}
    end
  attributes = { :linkcss => '' }.merge(attributes)
  doing :adoc, target
  args = %W[asciidoc --unsafe -o #{target}] + args +
         attributes.map { |k,v| ["-a", "#{k}=#{v}"] }.flatten +
         [ (verbose ? '--verbose' : nil), src].compact
  sh(*args)
end

task(:clean_doing) { doing(:clean, "#{CLEAN.length} file(s)") }
task :clean => :clean_doing

task(:clobber_doing) { doing(:clobber, "#{CLOBBER.length} file(s)") }
task :clobber => :clobber_doing
