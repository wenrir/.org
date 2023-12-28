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
PACMAN-exists: ; @which pacman> /dev/null 2>&1
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


.PHONY: install-ros
## Install roswell and initialises default lisp intepreter(arch only)
install-ros: PACMAN-exists
	yes | sudo pacman -S roswell
	ros


change-script-permissions:
	@chmod -R u+x $(PROJECT_DIR)/init/scripts

.PHONY: install-std
## Install standard packages (arch only)
install-std: PACMAN-exists
	$(shell $(PROJECT_DIR)/init/scripts/std-tools.sh)

.PHONY: install-doom
## Install doom (arch only)
install-doom: PACMAN-exists ROS-exists
	$(shell $(PROJECT_DIR)/init/scripts/doom.sh)

.PHONY: install-pyenv
## Install packages (arch only)
install-pyenv: PACMAN-exists
	$(shell $(PROJECT_DIR)/init/scripts/pyenv.sh)

.PHONY: setup
## Setup script.
setup: PACMAN-exists
	$(shell $(PROJECT_DIR)/init/scripts/setup.sh)
	$(shell $(PROJECT_DIR)/init/scripts/gpg.sh)

.PHONY: install
## Install packages (arch only)
install: PACMAN-exists ROS-exists change-script-permissions install-std install-doom install-pyenv

.PHONY: help
help:
	@echo "$$(tput setaf 2)Make rules:$$(tput sgr0)";sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## /---/;td" -e"s/:.*//;G;s/\\n## /===/;s/\\n//g;p;}" ${MAKEFILE_LIST}|awk -F === -v n=$$(tput cols) -v i=4 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"- %s%s%s\n",a,$$1,z;m=split($$2,w,"---");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;}printf"%*s%s\n",-i," ",w[j];}}'

# end
