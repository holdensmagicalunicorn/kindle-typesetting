Overview
===

This repository shows how to typeset documents for Kindle using LaTeX.
Amazon has based their ebook format MOBI on HTML, which has a number
of advantages: easy to search, easy to resize the text, adequate
typesetting is "free" to publishers, and HTML is a ubiquitous
document format.
Unfortunately, it's difficult to make manuscripts look good when
the markup is HTML.
Despite recent efforts to incorporate [basic ideas][js] from TeX,
HTML and CSS simply aren't expressive enough for the detailed
typesetting that is necessary for beautiful documents.
Both [The TeXbook][texbook] and [Digital Typography][dt] are good
books to read if you want to know more about the many and subtle
problems that have to be solved for high-quality typesetting.

[js]: http://www.dirigibleflightcraft.com/kindle/
[texbook]: http://www.amazon.com/TeXbook-Donald-Knuth/dp/0201134489
[dt]: http://www.amazon.com/Digital-Typography-Center-Language-Information/dp/1575860112/ref=sr_1_1?s=books&ie=UTF8&qid=1307270558&sr=1-1

There are two parts to this README.
The first is a quick description of how to target Kindle when
typesetting with LaTeX.
Fortunately, Kindle 3 includes a PDF viewer, so viewing LaTeX documents
on a Kindle is just a matter of creating the PDF and sending it to
a Kindle.
The second part is a discussion of fonts.
Kindle is a relativly low-resolution device, and Computer Modern
is not an especially good font at low resolutions.
Part two is a discussion of the issue and a final recommendation.

Part One: Typesetting
===

The Kindle screen is 3.6in x 4.8in.
The available height is about 4.5in, because the bottom of the screen
is used to indicate location in the document.
As for margins, the PDF viewer seems to automatically scale documents so 
they have an eighth-inch margin.
As a result, I used the following parameters with the `geometry` package.

	  \usepackage[paperwidth=3.6in,paperheight=4.5in,total={3.35in,4.25in},
	    includefoot]{geometry}

Using a 10pt font, I was seeing about fifty characters per line.
The text was still a bit small for my eyes, so I found myself typesetting 
at 11pt and accepting some bad breaks.
Your mileage may vary.

This paper size means you cannot trivially take an existing TeX
document and typeset it for Kindle.
Displayed math equations, code, figures, and tables will need to
be revisited and possibly redesigned to fit on Kindle's screen.
If you care about quality, however, I belive the results are worth it.
You need only compare a manuscript typeset with LaTeX to any MOBI
book you have.

Part Two: Fonts
===

TeX is a typesetting system that doesn't care how glyphs are rendered.
It only locates them.
Its output is a file in DVI format that is resolution independent.
It specifies what glyphs need to be displayed and where, but it
doesn't specify at what resolution to display them.
When Knuth wrote TeX, he wrote a companion system called Metafont to
create glyphs at specified resolutions for printing.

Knuth also designed a new font, Computer Modern, when he wrote 
[Metafont][mf].
Computer Modern is highly parameterized.
Where an Open Type font may only have a few parameters to affect the
shape of glyphs at different sizes and weights, Computer Modern has
about sixty parameters that can be modified to affect how glyphs are drawn.
This flexibility means that Computer Modern, when tuned properly, can
look good at high resolutions, low resolutions, and at large point sizes
as well as small.

[mf]: http://www.amazon.com/Computers-Typesetting-Metafont-Book/dp/0201134454/ref=sr_1_1?s=books&ie=UTF8&qid=1307273962&sr=1-1

Metafont was created in the late seventies and early eighties, before
Postscript.
Now in 2011, the TeX community has moved away from DVI and to PDF
as the target document format.
LaTeX and TeX still exist in their orginal form, but pdfTeX (luaTeX)
and pdfLaTeX (luaLaTeX) use different back ends to target PDF.
Computer Modern and its related math fonts are freely available in 
Postscript, so for the most part, there is a complete solution for
creating LaTeX documents for Kindle.

But there is a problem.
The Computer Modern postscript fonts are too light when drawn at
Kindle's low resolution.
Computer Modern looks good on high-resolution printers, but strokes
can become "invisible," at lower resolutions.
With Metafont, this problem is solved by tweaking parameters to
thicken strokes when printing to low-resolution devices.
There is no such tuning available with the Postscript fonts.
On the Kindle, for example, it's noticeable on the bottom curves of u,
c, and a.

There are three possible solutions.
First, accept Computer Modern for what it is.
Second, use Open Type or other Postscript fonts, which is really
only acceptable if you aren't typesetting mathematics.
Three, try to use Metafont and put bitmapped fonts in the PDF.
There is also a fourth, hybrid solution.
Concrete Modern is an alternative to Computer Modern that was designed
specifically for low-resolution devices and has two math fonts that
can be used with it (AMS Euler and Concrete Math).
It looks good on Kindle.
Portions of it are available in Postscript format, but glyphs for
some faces and the math fonts must still be generated with Metafont.

For those who want the bottom line: use Concrete Modern if you are
typesetting math.
It looks much better than Computer Modern on the Kindle, and the
bitmapped fonts are passable for their occasional use in most
documents.
If you are not typesetting math, stay clear of Computer Modern and
pick another Postscript or Open Type font.

Using bitmapped fonts with Kindle
---

I experimented with using bitmapped fonts on Kindle and did not have
much success.
I don't understand how the built-in PDF viewer is rendering bitmapped
fonts, and the results ran counter to what I expected.

When using bitmapped fonts, the normal process is to create a DVI
file, use `dvips` to create postscript, and use `pstopdf` to convert
that to PDF.
The resolution choice is made when converting to Postscript, and
Metafont is invoked to create glyphs at the chosen resolution.

There is another aspect to creating the glyphs, though.
Metafont has the notion of _mode_, which indicates the target
printing device.
Modes are really parameter settings to tune the glyphs for the
chosen output device.
For example, different printers use different ink which bleeds in
different ways when printed on paper.
Thickness of lines needs to be adjusted based on these properties.

So if we're creating bitmapped fonts for Kindle, we need a Kindle 
mode.
I experimented with several by modifying the `modes.mf` file that
comes with my TeX distribution and regenerating the Metafont 
base.

	  % cd /usr/local/texlive/2010/texmf-dist/metafont/misc
	  % mf -ini "plain; input modes; dump"
	  % cd ../../../texmf-var/web2c/metafont
	  % mv ../../../texmf-dist/metafont/misc/plain.base .
	  % rm mf.base 
	  % ln plain.base mf.base

I experimented with glyphs at 167dpi (Kindle's native display resolution),
300dpi, and 600dpi.
The 167dpi and 300dpi glyphs looked awful.
The 300dpi glyphs are visibly pixelated, and the 167dpi glyphs are
even worse.
The 600dpi glyps are much better but still a little fuzzy if you look 
closely.
Unfortunately, I don't know how the PDF viewer is handling the bitmaps,
and so I wasn't able to get to the bottom of _why_ they display like
they do.

As another approach, I tried creating PNG images of pages to bypass
the PDF viewer.
This is possible using `dvipng`, which creates one image per page
of the document.
This isn't practical for creating documents, but I was successful
in creating good page images for viewing on the Kindle.
This helped to convince me that the issue is somewhere in how the
PDF viewer is rendering the bitmapped glyphs.

LuaLaTeX falls back bitmapped fonts when needed.
They are generated at 600dpi, which is passable if only used
occasionally, and I haven't found a way to do better.

