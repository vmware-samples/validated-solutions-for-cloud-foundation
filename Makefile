.PHONY: docs-install docs-serve docs-serve-live docs-build docs-uninstall

docs-install:
	pip3 install mkdocs-material
	pip3 install --requirement .github/workflows/requirements.txt

docs-serve:
	mkdocs serve

docs-serve-live:
	mkdocs serve --livereload -w ./

docs-build:
	mkdocs build

docs-uninstall:
	pip uninstall mkdocs-material mkdocs -y
	pip uninstall -r .github/workflows/requirements.txt -y
