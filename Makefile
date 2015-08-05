#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: clean reallyclean test
BaseUrl=http://xenbits.xen.org/xsa
PatchList=patchlist.csv
PatchFiles=$(shell cat patchlist.csv)
all: $(PatchFiles)
%.patch:
	wget -q -nc $(BaseUrl)/$@
reallyclean:
	rm -f $(XSAUrlList)
clean:
	rm -f $(PatchList) *.patch
test:
	@echo $(PatchFiles)
