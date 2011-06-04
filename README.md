Making a metafont base with new modes
===

To make a metafont base with new modes:

	  % cd /usr/local/texlive/2010/texmf-dist/metafont/misc
	  % mf -ini "plain; input modes; dump"
	  % cd ../../../texmf-var/web2c/metafont
	  % mv ../../../texmf-dist/metafont/misc/plain.base .
	  % mv mf.base mf-original.base
	  % ln plain.base mf.base
