MODE=kindlethreezerozerobfiveftwo

%.dvi: %.tex
	latex $<

%.ps: %.dvi
	dvips -o $@ -u /dev/null -mode $(MODE) -D 300 $<

%.pdf: %.ps
	/usr/bin/pstopdf -o $@ $<

clean:
	rm -f example.{ps,dvi,aux,log}

distclean: clean
	rm -f example.pdf

