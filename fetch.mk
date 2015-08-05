#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: clean reallyclean test
BaseUrl=http://xenbits.xen.org/xsa
AdvisoryHtml=advisory-NNN.html
XSAList=$(shell seq 26 139)
XSAUrlList=$(foreach i,$(XSAList),$(subst NNN,$(i),$(AdvisoryHtml)))
PatchList=patchlist.csv
all: start $(XSAUrlList) $(PatchList) 
%.html:
	@wget -q -nc $(BaseUrl)/$@ || true
reallyclean: clean
	rm -f $(XSAUrlList)
clean:
	rm -f $(PatchList) *.patch
start:
	@echo "Downloading advisories from: $(BaseUrl)..."
$(PatchList): 
	@echo "Extracting list of patches..."
	@grep -P "^<a href=.*?patch\">" *.html > /tmp/grepList.txt
	@cat  /tmp/grepList.txt | sed 's/^.*<a href="\(xsa.*patch\)">.*$$/\1/'p > $@
test:
	@echo $(XSAUrlList)
