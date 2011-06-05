MODE=kindlesixzerozerobzerofzero

%.dvi: %.tex
	latex $<

%.ps: %.dvi
	dvips -o $@ -u /dev/null -mode $(MODE) -D 600 $<

%.pdf: %.ps
	/usr/bin/pstopdf -o $@ $<

lualatex-example.pdf: lualatex-example.tex
	lualatex lualatex-example

clean:
	rm -f latex-example.{ps,dvi,log,aux}
	rm -f lualatex-example.{log,aux}

distclean: clean
	rm -f latex-example.pdf lualatex-example.pdf

