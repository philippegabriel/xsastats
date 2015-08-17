#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: FetchPatches Patchfiles clean reallyclean display test
BaseUrl=http://xenbits.xen.org/xsa
AdvisoryHtml=advisory-NNN.html
XSAList=$(shell seq 26 139)
XSAUrlList=$(foreach i,$(XSAList),$(subst NNN,$(i),$(AdvisoryHtml)))
PatchList=patchlist.csv
PatchFiles=patchfiles.ok
XSAStats=XSAStats.csv
all: FetchAdvisories $(XSAUrlList) $(PatchList) FetchPatches $(PatchFiles) $(XSAStats) display
FetchAdvisories:
	@echo "Downloading advisories from: $(BaseUrl)..."
FetchPatches:
	@echo 'Downloading patches...'
%.html:
	@wget -q -nc $(BaseUrl)/$@ || echo 'not found' > $@
%.patch:
	@wget -q -nc $(BaseUrl)/$@
$(PatchList): $(XSAUrlList)
	@echo "Extracting list of patches..."
	@grep -P "^<a href=.*?patch\">" $^ > /tmp/grepList.txt
	@cat  /tmp/grepList.txt | sed 's/^.*<a href="\(xsa.*patch\)">.*$$/\1/'p > $@
$(PatchFiles): $(shell cat $(PatchList))
	touch $@
$(XSAStats): $(PatchFiles)
	@echo 'Generating stats...'
	@grep '^+++' *.patch > /tmp/grepPatches.txt
	@sed 's/^\(xsa[0-9]*\).*+++ .\/\([[:graph:]]*\).*$$/\2,\1/'  /tmp/grepPatches.txt | sort | uniq > $@
clean:
	rm -f $(XSAStats) $(PatchFiles) $(PatchList)
reallyclean: clean
	rm -f $(XSAUrlList) *.patch
display:
	@echo '#######################Files changed per xsa###############################'
	@cat $(XSAStats)
test:
	@echo $(XSAUrlList)
