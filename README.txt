= seacrest

* http://wiki.github.com/panpainter/seacrest

== DESCRIPTION:

A collection of tools for web masters, designers and developers to create and maintain a semantic and healthy codebase

== FEATURES/PROBLEMS:

* Need to implement last modified optional for Sitemap Generator

=== TODO:
Build the following

* Identify broken URLs (internal, external and resources)
* Identify any duplicate META descriptions
* Identify missing headings from document structure
* Identify duplicate page titles
* Find orphaned IDs and classes declared in any CSS files but no longer in use in your HTML files
* Find orphaned images no longer being called from HTML/CSS
* Generate a Google Sitemap
* The command line interface would allow you to run the entire suite or each tool individually via triggers.

==== General TODO's:
 * Need a general utilities file/class/whatever
  * Extract "traverse" method out from the duplicated locations (currently code is used in both CSScrubber and the Sitemap Generator)

==== CSScrubber

===== Need to haves
 * Compare CSS and HTML files
 * Traverse a full directory and compare all the files with one another
 * Find CSS files linked within HTML files (may not live inside a known directory) ??? -> may be moot with proper directory traversal
 * Traverse a live site and compare the files with one another

===== Nice to haves
 * Find a way to know what selectors *are* being used in an HTML file, even if they're not listed in the CSS file.
 * Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default

== SYNOPSIS:

None yet

== REQUIREMENTS:

* csspool (>= 0.2.6)
* Nokogiri (>= 1.3.1.20090611092310)

== INSTALL:

* Make any necessary changes to the config/config.yml file

== LICENSE:

(The MIT License)

Copyright (c) 2009 Matthew Anderson, Brandon Caplan and Michael Tierney

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
