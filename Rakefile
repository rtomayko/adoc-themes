$LOAD_PATH.unshift 'lib'
require 'rake/clean'
require 'theme'

include FileTest

VERS =    File.read('VERSION')

task 'default' => 'all'

task 'all' => [ 'stylesheets', 'site' ]

desc 'Build all examples and test files under site'
task 'site'

desc 'Build CSS for all themes'
task 'stylesheets'

desc 'Build distributable tarball under dist'
task 'dist'

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

require 'erb'
THEME_TEMPLATE = ERB.new(File.read("site/theme.txt.erb"))
INDEX_TEMPLATE = ERB.new(File.read("site/index.txt.erb"))

file 'site/src' do |f|
  doing :ln, f.name
  ln_s '../src', f.name, :force => true
end
task 'site' => 'site/src'
CLOBBER.include 'site/src'


file 'site/stylesheets' do |f|
  doing :ln, f.name
  ln_s '../stylesheets', f.name, :force => true
end
task 'site' => 'site/stylesheets'
CLOBBER.include 'site/stylesheets'


Theme.each do |theme|

  prereqs = [
    "src/#{theme.name}.txt",
    "site/src",
    "site/theme.txt.erb"
  ]
  file "site/#{theme.name}.txt" => prereqs do |f|
    doing :erb, f.name
    File.open("#{f.name}+", 'wb') do |io|
      io.write(THEME_TEMPLATE.result(binding))
    end
    mv "#{f.name}+", f.name
  end
  task 'site:text' => "site/#{theme.name}.txt"
  CLEAN.include "site/#{theme.name}.txt+"
  CLOBBER.include "site/#{theme.name}.txt"

  prereqs = [
    "site/#{theme.name}.txt",
    'site/xhtml11-article.conf',
    'site/asciidoc.conf',
    "stylesheets/#{theme.name}.css",
    "src/#{theme.name}.css",
    "site/src",
    "site/images/icons"
  ]
  file "site/#{theme.name}.html" => prereqs do |f|
    asciidoc f.prerequisites.first, f.name,
      '-f', 'site/theme.conf',
      :theme => theme.name,
      :stylesdir => 'src', # XXX: switch to stylesheets to use full ver
      :iconsdir  => 'images/icons'
  end
  task 'site:indexes' => "site/#{theme.name}.html"
  CLOBBER.include "site/#{theme.name}.html"


  manprereqs = [
    "site/asciidoc.1.txt",
    "site/xhtml11-manpage.conf"
  ] + prereqs
  file "site/#{theme.name}-manpage.html" => manprereqs do |f|
    asciidoc manprereqs.first, f.name,
      '-d', 'manpage',
      :theme => theme.name,
      :stylesdir => 'src'
  end
  task "site:manpages" => "site/#{theme.name}-manpage.html"
  CLOBBER.include "site/#{theme.name}-manpage.html"


  prereqs = [
    "site/userguide.txt",
    'site/xhtml11-article.conf',
    'site/asciidoc.conf',
    "src/#{theme.name}.css"
  ]
  file "site/#{theme.name}-format.html" => prereqs do |f|
    asciidoc prereqs.first, f.name,
      :theme => theme.name,
      :stylesdir => 'src',
      :iconsdir  => 'images/icons'
  end
  task "site:format" => "site/#{theme.name}-format.html"
  CLOBBER.include "site/#{theme.name}-format.html"

end

task 'site' => %w[site:text site:indexes site:manpages site:format]

file "site/index.txt" => FileList['site/index.txt.erb','src/*.txt'] do |f|
  doing :erb, f.name
  File.open("#{f.name}+", 'wb') do |io|
    io.write(INDEX_TEMPLATE.result(binding))
  end
  mv "#{f.name}+", f.name
end
task 'site:text' => "site/index.txt"
CLEAN.include "site/index.txt+"
CLOBBER.include "site/index.txt"


file 'site/index.html' => %w[site/index.txt site/stylesheets site/xhtml11-article.conf] do |f|
  asciidoc 'site/index.txt', f.name,
    :stylesdir => 'stylesheets',
    :theme => 'bare'
end
CLOBBER.include 'site/index.html'
task 'site:indexes' => 'site/index.html'

file 'site/hacking.txt' => %w[HACKING] do |f|
  ln 'HACKING', f.name, :force => true
end
CLEAN.include 'site/hacking.txt'


file 'site/hacking.html' => %w[site/hacking.txt site/stylesheets] do |f|
  asciidoc 'site/hacking.txt', f.name,
    :stylesdir => 'stylesheets',
    :theme => 'bare'
end
CLOBBER.include 'site/hacking.html'
task 'site' => 'site/hacking.html'


directory 'site/images'

file 'site/images/icons' => %w[site/images] do |f|
  rm_rf f.name
  asciidoc_config =
    %w[/etc/asciidoc /usr/local/etc/asciidoc /opt/local/etc/asciidoc].
      detect { |dir| File.directory?(dir) }
  if asciidoc_config
    mkdir_p 'site/images'
    doing 'ICONS', "site/images/icons (from #{asciidoc_config}/images/icons)"
    cp_r "#{asciidoc_config}/images/icons", f.name, :preserve => true
  else
    STDERR.puts "warn: cannot copy asciidoc icons" +
      "(couldn't find AsciiDoc's config directory.)"
      mkdir_p f.name
  end
end
task 'site' => 'site/images/icons'
CLOBBER.include 'site/images/icons'

# ---------------------------------------------------------------------------
# Shipping it out
# ---------------------------------------------------------------------------

# Push website up to tomayko.com
task 'publish' => %w[site] do |t|
  doing :pub, "tomayko.com"
  sh <<-EOF
    rsync -aL \
          --delete \
          --delete-excluded \
          site/ tomayko.com:/src/adoc-themes
  EOF
end

TARNAME = "adoc-themes-#{VERS}"

# Build tarball under dist.
file "dist/#{TARNAME}.tar.gz" => %w[stylesheets site] do |f|
  content = FileList['src/*.css','stylesheets/*.css']
  content.include 'site/*.{conf,html,txt}'
  content.include 'site/images/icons/***'
  content.include 'README.txt', 'HACKING', 'Rakefile'
  doing :tar, f.name
  rm_rf "#{TARNAME}"
  mkdir "#{TARNAME}"
  content.each do |file|
    if File.directory?(file)
      mkdir_p file
    else
      mkdir_p "#{TARNAME}/#{File.dirname(file)}"
      ln file, "#{TARNAME}/#{file}"
    end
  end
  mkdir_p 'dist'
  rm_f f.name
  sh "tar", "czf", f.name, TARNAME
  rm_rf TARNAME
end
task 'dist' => "dist/#{TARNAME}.tar.gz"

# Push tarball up to dist site.
task 'release' => %w[dist] do |t|
  sh <<-EOF
    rsync -av dist/ tomayko.com:/dist/adoc-themes
  EOF
end


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
