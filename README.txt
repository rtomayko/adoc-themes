AsciiDoc Theme CSS
==================
Ryan Tomayko <r@tomayko.com>

*AsciiDoc* is a (_mostly_ humane) text document format for writing short
documents, articles, books and man pages. It includes a toolchain capable of
producing HTML4, XHTML, DocBook, man, and LaTeX. This file (link:README.txt[])
is AsciiDoc . `git(1)`'s manual pages and other documentation is written in AsciiDoc.

*AsciiDoc* generates basically good semantic markup styled with CSS and includes
support for themeing with pure CSS. The default theme included in AsciiDoc is
functional but is somewhat lacking in typographic consistencies; it is also
quite _blue_.

This package includes a variety of additional themes and a framework for
assembling them.

[CAUTION]
.CAUTION
This project was started on March 4, 2008 and is currently in the
very early stages of development. Not all themes style the gambit of supported
AsciiDoc markup.

Themes
------

Without further ado, here are the themes:

=== bare.css

The "bare" theme is meant to act as a starting point for other themes. It
includes a basic level of  layout and typographic styling but tries to remain
otherwise vanilla in its visual appeal.

link:./examples/bare-README.html[This Page] |
link:./examples/bare-asciidoc.1.html[`asciidoc(1)`] |
link:./examples/bare-userguide.html[User Guide]

=== FreeBSDish

link:./examples/freebsdish-README.html[This Page] |
link:./examples/freebsdish-asciidoc.1.html[`asciidoc(1)`] |
link:./examples/freebsdish-userguide.html[User Guide]

See Also
--------

 * http://www.methods.co.nz/asciidoc/[AsciiDoc Homepage]
 * http://kernel.org/pub/software/scm/git/docs/[git(7) Manual Page]
 * http://kernel.org/pub/software/scm/git/docs/user-manual.html[Git User's Manual]
 * http://www.textism.com/tools/textile/[Textile]
 * http://daringfireball.net/projects/markdown/[Markdown]
 * http://docutils.sourceforge.net/rst.html[reStructuredText]

// vim: ft=asciidoc
