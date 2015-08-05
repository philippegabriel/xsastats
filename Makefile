#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: clean reallyclean test
BaseUrl=http://xenbits.xen.org/xsa
PatchList=patchlist.csv
XSAStats=XSAStats.csv
PatchFiles=$(shell cat patchlist.csv)
all: start $(PatchFiles) $(XSAStats)
start:
	@echo 'Downloading patches...'
%.patch:
	@wget -q -nc $(BaseUrl)/$@
$(XSAStats):
	@echo 'Generating stats...'
	@grep '^+++' $(PatchFiles) > /tmp/grepPatches.txt
	@sed 's/^\(xsa[0-9]*\).*+++ .\/\([[:graph:]]*\).*$$/\2,\1/'  /tmp/grepPatches.txt | sort | uniq > $@
clean:
	rm -f $(XSAStats)
display:
	@echo '#######################Files changed per xsa###############################'
	@cat $(XSAStats)
