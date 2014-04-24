
# SimpleEpubReader

SimpleEpubReader is the bare minimum functionality needed in order to work with the EPUB file format. It showcases some fundamental implementation details of conforming to the EPUB specification described by the International [Digital Publishing Forum][EPUB spec].

## Features

1. Parsing EPUB files
 1. Opening zip archives
 1. Reading data from zip file without extracting the whole archive
 1. Processing EPUB metadata
 1. Processing the `container.xml`
 1. Processing the root file
 1. Processing Table of contents
 1. Showing the table of contents in a table view
 1. Displaying the EPUB contents in a UIPageViewController
 1. Loading web page resources located inside the zip archive via a custom NSURLProtocol subclass
 1. Bookmarks support (comming soon...)

[EPUB spec]: http://idpf.org/epub
