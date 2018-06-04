#
# Build file for creating DMG files.
#
# The DMG packager looks for a template.dmg.bz2 for using as its
# DMG template. If it doesn't find one, it generates a clean one.
#
# If you create a DMG template, you should make one containing all
# the files listed in $(SOURCE_FILES) below, and arrange everything to suit
# your style. The contents of the files themselves does not matter, so
# they can be empty (they will be overwritten later).
#
# Remko Tronçon
# http://el-tramo.be/about
# Licensed under the MIT License. See COPYING for details.


################################################################################
# Customizable variables
################################################################################

NAME ?= view3dscene
VERSION ?= $(shell ../$(NAME) --version)

SOURCE_DIR ?= .
SOURCE_FILES ?= $(NAME).app

TEMPLATE_DMG ?= template.dmg

# Max size of data inside archive
SIZE ?= 2g

################################################################################
# DMG building. No editing should be needed beyond this point.
################################################################################

# Crazy way how to make string lowercase in Makefile copied from
# https://stackoverflow.com/questions/664601/in-gnu-make-how-do-i-convert-a-variable-to-lower-case
lowercase = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
LOWER_NAME = $(call lowercase,$(NAME))

# We use lowercased name below, because by convention CGE webpages assume that
# released archives use 'glviewimage' not 'glViewImage'.
MASTER_DMG=$(LOWER_NAME)-$(VERSION)-macosx.dmg
WC_DMG=wc.dmg
WC_DIR=wc

.PHONY: all
all: $(MASTER_DMG)

$(TEMPLATE_DMG): $(TEMPLATE_DMG).bz2
	bunzip2 -k $<

$(TEMPLATE_DMG).bz2:
	@echo
	@echo --------------------- Generating empty template --------------------
	mkdir template
	hdiutil create -fs HFSX -layout SPUD -size $(SIZE) "$(TEMPLATE_DMG)" -srcfolder template -format UDRW -volname "$(NAME)"
	rmdir template
	bzip2 "$(TEMPLATE_DMG)"
	@echo

$(WC_DMG): $(TEMPLATE_DMG)
	cp $< $@

$(MASTER_DMG): $(WC_DMG) $(addprefix $(SOURCE_DIR)/,$(SOURCE_FILES))
	@echo
	@echo --------------------- Creating Disk Image --------------------
	mkdir -p $(WC_DIR)
	hdiutil attach "$(WC_DMG)" -noautoopen -quiet -mountpoint "$(WC_DIR)"
	for i in $(SOURCE_FILES); do  \
		rm -rf "$(WC_DIR)/$$i"; \
		ditto -rsrc "$(SOURCE_DIR)/$$i" "$(WC_DIR)/$$i"; \
	done
	#rm -f "$@"
	#hdiutil create -srcfolder "$(WC_DIR)" -format UDZO -imagekey zlib-level=9 "$@" -volname "$(NAME) $(VERSION)" -scrub -quiet
	WC_DEV=`hdiutil info | grep "$(WC_DIR)" | grep "Apple_HFS" | awk '{print $$1}'` && \
	hdiutil detach $$WC_DEV -quiet -force
	rm -f "$(MASTER_DMG)"
	hdiutil convert "$(WC_DMG)" -quiet -format UDZO -imagekey zlib-level=9 -o "$@"
	rm -rf $(WC_DIR)
	@echo --------------------- Finished Creating Disk Image: $@ --------------------
	@echo

.PHONY: clean
clean:
	-rm -rf $(TEMPLATE_DMG) $(MASTER_DMG) $(WC_DMG) template/ wc/
