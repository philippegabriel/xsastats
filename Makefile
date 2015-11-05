#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: FetchPatches Patchfiles clean reallyclean display test
BaseUrl=http://xenbits.xen.org/xsa/
AdvisoryHtml=advisory-NNN.html
configFile:=README.md
config=$(lastword $(shell grep $(1) $(configFile)))
firstXSA:=$(call config,'First XSA')
lastXSA:=$(call config,'Last XSA')
XSAList=$(shell seq $(firstXSA) $(lastXSA))
XSAUrlList=xsaURLList.csv
PatchList=patchlist.csv
ChunkList=chunklist.csv
XSAFileList=XSAFileList.csv
XSAStats=XSAStats.csv
all: $(XSAUrlList) FetchAdvisories $(PatchList) FetchPatches $(XSAFileList)  $(ChunkList) $(XSAStats) display
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
$(XSAFileList):
	@echo 'Generating stats...'
	grep '^+++' *.patch  | perl -n -e '/^(xsa[0-9]+).*?\/([[:graph:]]*).*$$/ & print "$$2;$$1\n"' | sort | uniq > $@
$(ChunkList):
	@echo 'Analysing diffs...'
	./chunk2csv.pl *.patch > $@	
$(XSAStats): $(XSAFileList) $(ChunkList)
	echo "####################################################################################" > $@
	echo "#               patches,file modified,xsa(s) in scope" >> $@
	echo "####################################################################################" >> $@
	./XSAacc.pl < $(XSAFileList) >> $@
	echo "####################################################################################" >> $@
	echo "#               patches,file modified & function,xsa(s) in scope" >> $@
	echo "####################################################################################" >> $@
	sort $(ChunkList) | uniq | ./XSAacc.pl >> $@
clean:
	rm -f *.csv
reallyclean: clean
	rm -f *.html *.patch
display: $(XSAStats)
	@cat README.md
	@cat $(XSAStats)
test: 
	@echo $(XSAList)
