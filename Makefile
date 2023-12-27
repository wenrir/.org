##
# .org Makefile
#
# @file
# @version 0.1
PROJECT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DEFAULT_BRANCH := main
SHELL := /bin/sh
.DEFAULT_GOAL := help
ROS-exists: ; @which ros > /dev/null 2>&1
TANGLE-exists: ; @ls $(PROJECT_DIR)/.tangle > /dev/null 2>&1

.PHONY: build
## Build tangle script
build: ROS-exists
	@ros build $(PROJECT_DIR)/util/tangle.ros && mv $(PROJECT_DIR)/util/tangle $(PROJECT_DIR)/.tangle

.PHONY: tangle
## Build tangle script
tangle: TANGLE-exists
	$(shell $(PROJECT_DIR)/.tangle)

.PHONY: update
## Update repository (and submodules) against main.
update:
	git pull origin $(DEFAULT_BRANCH)
	git submodule update --init --recursive

.PHONY: help
help:
	@echo "$$(tput setaf 2)Make rules:$$(tput sgr0)";sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## /---/;td" -e"s/:.*//;G;s/\\n## /===/;s/\\n//g;p;}" ${MAKEFILE_LIST}|awk -F === -v n=$$(tput cols) -v i=4 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"- %s%s%s\n",a,$$1,z;m=split($$2,w,"---");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;}printf"%*s%s\n",-i," ",w[j];}}'


# end
