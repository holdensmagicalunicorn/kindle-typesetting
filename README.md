Making a metafont base with new modes
===

To make a metafont base with new modes:

	  % cd /usr/local/texlive/2010/texmf-dist/metafont/misc
	  % mf -ini "plain; input modes; dump"
	  % cd ../../../texmf-var/web2c/metafont
	  % mv ../../../texmf-dist/metafont/misc/plain.base .
	  % mv mf.base mf-original.base
	  % ln plain.base mf.base


Pages as PNG images
===
You can use dvipng to render a page as an image.
Per the Amazon Kindle Publishing Guidelines, the image can be no more than
500x600.
I calculated a page size based on 167dpi, and that looked decent.

