#Download all patches from http://xenbits.xen.org/xsa
#And compute defect density metrics
#
.PHONY: clean reallyclean test
BaseUrl=http://xenbits.xen.org/xsa
AdvisoryHtml=advisory-NNN.html
XSAList=$(shell seq 26 139)
XSAUrlList=$(foreach i,$(XSAList),$(subst NNN,$(i),$(AdvisoryHtml)))
PatchList=patchlist.csv
all: $(XSAUrlList) $(PatchList)
%.html:
	wget -q -nc $(BaseUrl)/$@ || true
reallyclean:
	rm -f $(XSAUrlList)
clean:
	rm -f $(PatchList) *.patch
test:
	@echo $(XSAUrlList)
$(PatchList):
	grep -P "^<a href=.*?patch\">" *.html > /tmp/grepList.txt
	cat  /tmp/grepList.txt | sed "s/^\(.*\html\).*\(xsa.*patch\).*$$/\1,\2/"p > $@
test:
	echo $(XSAUrlList)
