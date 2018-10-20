VERSION = 2010

default:
	cd tools && make
	cd report && make

clean:
	cd report && make clean
	cd tools && make clean

release:
	cd tools && make
	cd report && make
	mkdir haskell$(VERSION) || true
	cp report/ht/*.html report/ht/*.png report/ht/*.css haskell$(VERSION)
	tar cvzf haskell$(VERSION)-html.tar.gz haskell$(VERSION)

# If you have an account on www.haskell.org, the following rules will upload
# the finished report to the correct places.
UPLOAD_HOST = www.haskell.org
UPLOAD_HTML_DIR = /home/haskell/onlinereport/haskell$(VERSION)
UPLOAD_DEFN_DIR = /home/haskell/definition

upload:
	ssh $(UPLOAD_HOST) "mkdir $(UPLOAD_HTML_DIR) || true"
	ssh $(UPLOAD_HOST) "mkdir $(UPLOAD_DEFN_DIR) || true"
	scp report/haskell.pdf $(UPLOAD_HOST):$(UPLOAD_DEFN_DIR)/haskell$(VERSION).pdf
	scp haskell$(VERSION)-html.tar.gz $(UPLOAD_HOST):$(UPLOAD_DEFN_DIR)
	ssh $(UPLOAD_HOST) "cd $(UPLOAD_HTML_DIR); tar xvzf $(UPLOAD_DEFN_DIR)/haskell$(VERSION)-html.tar.gz; mv haskell$(VERSION)/* .; rmdir haskell$(VERSION); rm -f index.html; ln -s haskell.html index.html"
