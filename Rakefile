require 'rake/clean'

THEMES =  %w[bare freebsdish]
CSS = THEMES.
        map{|t| ["#{t}.css","#{t}-manpage.css","#{t}-quirks.css"]}.
        flatten

# disable verbose output by default. Invoke like this to turn on:
# $ rake V=1 task ...
# ... or ...
# $ rake verbose task ... 
task(:verbose) { verbose(true) }
verbose(ENV['V'] == '1')

# give a status of what's going on (only when not in verbose mode)
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
  doing :doc, target
  args = %W[asciidoc --unsafe -o #{target} -a stylesdir=#{Dir.pwd}] +
         attributes.map { |k,v| ["-a", "#{k}=#{v}"] }.flatten +
         [ (verbose ? '--verbose' : nil), src].compact
  sh(*args)
end

(THEMES - ['bare']).each do |theme|
  file "#{theme}.css" => "#{theme}.css.in" do |f|
    doing :css, f.name
    sh "cat bare.css #{f.name}.in > #{f.name}"
  end
  file "#{theme}-manpage.css" => "#{theme}-manpage.css.in" do |f|
    doing :css, f.name
    sh "cat bare-manpage.css #{f.name}.in > #{f.name}"
  end
  file "#{theme}-quirks.css" => "#{theme}-quirks.css.in" do |f|
    doing :css, f.name
    sh "cat bare-quirks.css #{f.name}.in > #{f.name}"
  end
  CLEAN.include "#{theme}{,-manpage,-quirks}.css"
  desc "Build #{theme} stylesheets"
  task theme => [ "#{theme}.css", "#{theme}-manpage.css", "#{theme}-quirks.css" ]
end

# Examples ==================================================================

EX_MAN_SRCS = FileList['examples/*.1.txt']
EX_ART_SRCS = FileList['examples/*.txt'].reject { |f| f =~ /\.1\.txt$/ }
EX_SRCS = EX_MAN_SRCS + EX_ART_SRCS

EX_CONF = FileList['examples/*.conf']
EX_HTML = EX_SRCS.map { |f| f.sub(/\.txt/, '.html') }

EX_ART_SRCS.each do |srcfile|
  THEMES.each do |theme|
    prereqs = FileList[
      srcfile, 
      'examples/xhtml11-article.conf', 
      'examples/asciidoc.conf',
      "#{theme}.css",
      "#{theme}-quirks.css"
    ]
    destfile = srcfile.sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc srcfile, destfile, :theme => theme
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
      "#{theme}.css",
      "#{theme}-quirks.css",
      "#{theme}-manpage.css"
    ]
    destfile = srcfile.sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc srcfile, destfile, '-d', 'manpage', :theme => theme
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

desc 'Build all examples'
task 'examples'

task :clean_doing do
  doing :clean, "#{CLEAN.length} file(s)"
end
task :clean => :clean_doing

task :default => :examples
