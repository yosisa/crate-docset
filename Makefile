CRATES = crates
DOCSET = docset

latest/%: update/% $(DOCSET)/%
	cd $(CRATES)/$* && git checkout $$(git describe --abbrev=0); \
		cargo docset || cd $(*F) && cargo docset; \
		git switch -
	mv $(CRATES)/$*/target/docset/$(*F).docset $(DOCSET)

HEAD/%: update/% $(DOCSET)/%
	cd $(CRATES)/$* && \
		git checkout $$(git remote show origin | grep "HEAD branch" | sed 's/.*: //'); \
		cargo docset || cd $(*F) && cargo docset
	mv $(CRATES)/$*/target/docset/$(*F).docset $(DOCSET)

update/%: $(CRATES) FORCE
	if [ -d $(CRATES)/$* ]; then \
		cd $(CRATES)/$* && git pull origin; \
	else \
		git clone https://github.com/$*.git $(CRATES)/$*; \
	fi

$(DOCSET)/%: FORCE
	-rm -r $(DOCSET)/$(*F).docset 2>/dev/null

$(CRATES):
	mkdir $(CRATES)

$(DOCSET):
	mkdir $(DOCSET)

FORCE:

.PHONY: FORCE
