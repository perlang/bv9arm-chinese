# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -a -b latex -v
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

RELEASE_DATE=`date -r conf.py +"%Y-%m-%d"`

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
#%: Makefile
pdf:
	$(SPHINXBUILD) $(SPHINXOPTS) -D today=${RELEASE_DATE} . "$(BUILDDIR)"
	(cd $(BUILDDIR); make)
	cp "$(BUILDDIR)/Bv9ARM.pdf" "$(SOURCEDIR)"

clean::
	rm -rf $(BUILDDIR)
	rm -f Bv9ARM.pdf
