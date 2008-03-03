require 'rake/clean'

STYLESHEETS = FileList['stylesheets/*.css']
THEMES =  FileList['stylesheets/*.css'].
            reject { |f| f =~ /-(manpage|quirks)\.css$/ }.
            map { |f| f.sub(/stylesheets\/(.*)\.css/, '\1') }

# Run asciidoc with some default options and attributes.
def asciidoc(*args)
  sh 'asciidoc', '--unsafe', '--verbose',
    '-a', "stylesdir=#{Dir.pwd}/stylesheets",
    *args
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
      "stylesheets/#{theme}.css"
    ]
    destfile = srcfile.sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc '-a', "theme=#{theme}", 
               '-o', destfile,
                srcfile
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
      "stylesheets/#{theme}.css",
      "stylesheets/#{theme}-manpage.css"
    ]
    destfile = srcfile.sub(/examples\/(.*)\.txt/, "examples/#{theme}-\\1.html")
    file destfile => prereqs do
      asciidoc '-d', 'manpage',
               '-a', "theme=#{theme}", 
               '-o', destfile,
                srcfile
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
