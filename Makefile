#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: FetchPatches Patchfiles clean reallyclean display test
BaseUrl=http://xenbits.xen.org/xsa/
AdvisoryHtml=advisory-NNN.html
XSAList=$(shell seq 26 139)
XSAUrlList=xsaURLList.csv
PatchList=patchlist.csv
XSAStats=XSAStats.csv
all: $(XSAUrlList) FetchAdvisories $(PatchList) FetchPatches $(XSAStats) display
$(XSAUrlList):
	$(foreach i,$(XSAList),$(shell echo $(subst NNN,$(i),$(AdvisoryHtml)) >> $@))
FetchAdvisories:  $(XSAUrlList)
	@echo "Downloading advisories from: $(BaseUrl)..."
	wget -q -nc --base=$(BaseUrl) -i $< || true
$(PatchList):
	@echo "Extracting list of patches..."
	perl -n -e '/^<a href=\"(.*?patch)\">/ && print "$$1\n"' *.html > $@
FetchPatches: $(PatchList)
	@echo 'Downloading patches...'
	wget -q -nc --base=$(BaseUrl)  -i $<
$(XSAStats): $(PatchFiles)
	@echo 'Generating stats...'
	grep '^+++' *.patch  | perl -n -e '/^(xsa[0-9]+).*?\/([[:graph:]]*).*$$/ & print "$$2,$$1\n"' | sort | uniq > $@
clean:
	rm -f *.csv
reallyclean: clean
	rm -f *.html *.patch
display:
	@echo '#######################Files changed per xsa###############################'
	./XSAacc.pl < $(XSAStats)
test: $(XSAUrlList)
	@cat $(XSAUrlList)
