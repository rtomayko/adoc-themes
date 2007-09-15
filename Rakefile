require 'rake/clean'

STYLESHEETS = FileList['stylesheets/*.css']

def asciidoc(*args)
  sh 'asciidoc',
    '--unsafe',
    '-a', "stylesdir=#{Dir.pwd}/stylesheets",
    '-a', 'theme=handbookish',
    '--verbose',
    *args
end

file 'article.html' => [ 'article.txt' ] + STYLESHEETS do |f|
  asciidoc f.prerequisites.first
end
CLEAN.include 'article.html'

file 'manpage.html' => [ 'manpage.txt' ] + STYLESHEETS do |f|
  asciidoc '-d', 'manpage', f.prerequisites.first
end
CLEAN.include 'manpage.html'

task :default => [ 'article.html', 'manpage.html' ]
