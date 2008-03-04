AsciiDoc Themes
===============
Ryan Tomayko <r@tomayko.com>
v1, March 2008

*AsciiDoc* is a (_mostly_ humane) text document format for writing short
documents, articles, books and man pages. It includes a toolchain capable of
producing HTML4, XHTML, DocBook, man, and LaTeX. This file (link:README.txt[])
is AsciiDoc . `git(1)`'s manual pages and other documentation is written in AsciiDoc.

*AsciiDoc* generates basically good semantic markup, is styled with external
CSS, and includes support for themeing. The default theme included in AsciiDoc
is functional but is somewhat lacking in typographic consistencies; it is also
quite _blue_.

This package includes a variety of additional themes and a framework for
assembling them.

[CAUTION]
.CAUTION
This project was started on March 4, 2008 and is currently in the very early
stages of development. There's not many themes yet and not all themes style the
gambit of supported AsciiDoc markup. Also, I have not tested anything in any
version of Internet Explorer, yet.

Without further ado, let's get to the themes ...

`bare.css`
----------

The "bare" theme is meant as a starting point for other themes.  It includes a
basic level of structural and typographic styling but tries to remain otherwise
vanilla in its visual appeal. The manpage styles are based on the default theme
included with the http://bruji.com/bwana/[Bwana] manpage reader for MacOS X.

link:./examples/bare-README.html[This Page] |
link:./examples/bare-asciidoc.1.html[`asciidoc(1)`] |
link:./examples/bare-userguide.html[User Guide] |
link:./src/bare.css[bare.css] |
link:./src/bare-manpage.css[bare-manpage.css]


Handbookish
-----------

Inspired by http://freebsd.org/doc/en/books/handbook/[The FreeBSD Handbook],
one of The FreeBSD Documentation Project's many works of art, this theme is
probably most noticeable by its judicious use of _daemon red_ and its fatty
bold headings. FreeBSD's http://tinyurl.com/3afcwv[`sh(1)`] HTML manpage
(which I've nearly committed to memory) provided the template for the manpage
stylings.

link:./examples/handbookish-README.html[This Page] |
link:./examples/handbookish-asciidoc.1.html[`asciidoc(1)`] |
link:./examples/handbookish-userguide.html[User Guide] |
link:./src/handbookish.css[handbookish.css] |
link:./src/handbookish-manpage.css[handbookish-manpage.css]

See Also
--------

http://www.methods.co.nz/asciidoc/[AsciiDoc],
http://tomayko.com[Ryan Tomayko],
http://kernel.org/pub/software/scm/git/docs/[`git(7)`],
http://kernel.org/pub/software/scm/git/docs/user-manual.html[Git User's Manual],
http://www.textism.com/tools/textile/[Textile],
http://daringfireball.net/projects/markdown/[Markdown],
http://docutils.sourceforge.net/rst.html[reStructuredText],
http://bruji.com/bwana/[Bwana],
http://freebsd.org/doc/en/books/handbook/[The FreeBSD Handbook],
http://www.freebsd.org/cgi/man.cgi[FreeBSD 'Man Page Lookup'],
http://tinyurl.com/3afcwv[FreeBSD `sh(1)`]

// vim: ft=asciidoc ts=8 sw=8 sts=0 noexpandtab
