#############################################################################
#
#   Copyright (c) 2021 Windhover Labs, L.L.C. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name Windhover Labs nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#############################################################################

SPHINX_OPTS     ?=
SPHINX_BUILD    ?= sphinx-build
SPHINX_SOURCEDIR = .
SPHINX_BUILDDIR  = build/reference/default/target/docs
SPHINX_FSW_BUILD = reference/default

SHELL := /bin/bash

CONFIG_DIR   := config
GENERIC_TARGET_PATHS :=  $(shell find ${CONFIG_DIR} -mindepth 2 -maxdepth 20 -type f -name 'wh_config.yaml' | sed -r 's,^[^/]*/,,' | sed -r 's|/[^/]+$$||' | sort -u)
GENERIC_TARGET_NAMES := $(shell echo ${GENERIC_TARGET_PATHS} )
#TARGET_NAMES := core-only/pc-linux slim/pc-linux slim-apps-only/pc-linux full/pc-linux full-apps-only/pc-linux 
BUILD_TYPES  := host target
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

export PROJECT_SOURCE_DIR=${PWD}

help::
	@echo '---=== Buildliner ===---                                                        '
	@echo '                                                                                '
	@echo 'Specify a target to build.  Available targets are:                              '
	@echo '                                                                                '
	@echo '    deploy                  : This is a one time process that create your       '
	@echo '                              repository.  This can only be performed once.     '
	@echo '                                                                                '
	@echo '  Flight Software Builds                                                        '
	@echo '    core-only/pc-linux      : This builds only the Core Binary for Linux running'
	@echo '                              on a PC.                                          '
	@echo '    slim/pc-linux           : This builds the simplest, most basic build with   '
	@echo '                              the Core Binary and applications for scheduling,  '
	@echo '                              commanding, and telemetry.                        '
	@echo '    slim-apps-only/pc-linux : This builds the simplest, most basic build with   '
	@echo '                              the Core Binary and applications for scheduling,  '
	@echo '                              commanding, and telemetry.                        '
	@echo '    full/pc-linux           : This builds a full compliment of the Core Binary  '
	@echo '                              and the most common apps for all targets and      '
	@echo '                              use cases.                                        '
	@echo '    full-apps-only/pc-linux : This builds a full compliment of the Core Binary  '
	@echo '                              and the most common apps for all targets and      '
	@echo '                              use cases.                                        '
	@echo '    reference               : This is a reference build used to generate        '
	@echo '                              documentation. This will use platform and mission '
	@echo '                              configuration header files from the components    '
	@echo '                              source directory, i.e. apps/sch/fsw/mission_inc.  '
	@echo '    clean                   : This will clean all build flight software build   '
	@echo '                              targets.  This includes the Commander workspace,  '
	@echo '                              if one was generated.                             '
	@echo '                                                                                '
	@echo '                                                                                '
	@echo '  Utilities                                                                     '
	@echo '    python-env              : This generates a Python3 virtual environment in   '
	@echo '                              the "venv" directory with all the python          '
	@echo '                              modules required to use the Buildliner build      '
	@echo '                              system.                                           '
	@echo '    submodule-update        : This just updates all submodules.                 '
	@echo '                                                                                '
	@echo '                                                                                '
	@echo '  Documentation                                                                 '
	@echo '    reference               : This will build the reference version of the      '
	@echo '                              flight software, primarily used for documentation '
	@echo '                              purposes.  This will build using platform and     '
	@echo '                              mission configuration header files defined in the '
	@echo '                              respective source directories, i.e.               '
	@echo '                                  apps/sch/fsw/mission_inc,                     '
	@echo '                                  apps/sch/fsw/platform_inc                     '
	@echo '    docs                    : Generate all documentation from the reference     '
	@echo '                              build.                                            '
	@echo '    docs-doxygen            : Generate only the Doxygen documentation from the  '
	@echo '                              reference build.                                  '
	@echo '    docs-sphinx             : Generate the Sphinx documentation from the        '
	@echo '                              reference build.                                  '
       
	
.PHONY: help Makefile docs
	

$(GENERIC_TARGET_NAMES)::
	@echo 'Building '$@'.'
	@idx=1; \
	for name in $(GENERIC_TARGET_NAMES); do \
		if [ "$$name" == "$@" ] ; then \
			break; \
		fi; \
		((idx++)); \
	done; \
	TARGET_PATH=$$(echo ${GENERIC_TARGET_PATHS} | cut -d " " -f $$idx); \
		echo "Generating complete design/configuration definition file, wh_defs.yaml"; \
	if [ -f "$(CONFIG_DIR)/$$TARGET_PATH/wh_config.yaml" ]; then \
			mkdir -p build/$$TARGET_PATH/target; \
			python3 core/base/tools/config/wh_defgen.py $(CONFIG_DIR)/$$TARGET_PATH/ build/$$TARGET_PATH/target/wh_defs.yaml; \
	fi; \
		for buildtype in $(BUILD_TYPES); do \
		if [ -d "$(CONFIG_DIR)/$$TARGET_PATH/$$buildtype" ]; then \
				mkdir -p build/$$TARGET_PATH/$$buildtype; \
				(cd build/$$TARGET_PATH/$$buildtype; \
					/usr/bin/cmake -DBUILDNAME:STRING=$$TARGET_PATH -DBUILDTYPE:STRING=$$buildtype -G"Eclipse CDT4 - Unix Makefiles" \
						-DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE CMAKE_BUILD_TYPE=Debug $(ROOT_DIR); \
					$(MAKE) --no-print-directory); \
				fi \
		done;
	

docs-doxygen: 
	@echo 'Updating submodules'
	git submodule update --init --recursive
	mkdir -p build/${SPHINX_FSW_BUILD}/target; \
	(cd build/${SPHINX_FSW_BUILD}/target; cmake -DBUILDNAME:STRING=${SPHINX_FSW_BUILD} -DBUILDTYPE:STRING=target \
		-G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE CMAKE_BUILD_TYPE=Debug $(ROOT_DIR); make docs);
	
docs-sphinx: 
	@echo 'Updating submodules'
	git submodule update --init --recursive
	@echo 'Building $$SPHINX_FSW_BUILD.'
	mkdir -p build/${SPHINX_FSW_BUILD}/target; \
	(cd build/${SPHINX_FSW_BUILD}/target; cmake -DBUILDNAME:STRING=${SPHINX_FSW_BUILD} -DBUILDTYPE:STRING=target \
		-G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE CMAKE_BUILD_TYPE=Debug $(ROOT_DIR));
	@$(SPHINX_BUILD) -M html "$(SOURCE_DIR)" "$(SPHINX_BUILDDIR)" $(SPHINX_OPTS) -c build/$(SPHINX_FSW_BUILD)/target/docs $(O)
	@echo 'Completed'
	
docs: docs-doxygen docs-sphinx
	@echo 'Completed'

python-env::
	virtualenv -p python3 venv || exit -1
	(source venv/bin/activate || exit -1; pip install -r core/tools/auto-yamcs/src/requirements.txt || exit -1)
	@echo 'Created python3 virtual environment.                                            '
	@echo '                                                                                '
	@echo 'Activate:                                                                       '
	@echo '    source venv/bin/activate                                                    '
	@echo '                                                                                '
	@echo 'Deactivate:                                                                     '
	@echo '    deactivate                                                                  '
	@echo '                                                                                '

# Sample 'workspace' recipe
full/pc-linux-workspace::
	@echo 'Generating ground tools data.'
	@make -C build/full/pc-linux/target ground-tools
	@echo 'Generating Commander workspace.'
	@python3 core/base/tools/commander/generate_workspace.py build/full/pc-linux/commander_workspace/etc/registry.yaml build/fixedwing/gemini2/commander_workspace/
	@echo 'Generating XTCE'
	@core/tools/auto-yamcs/src/generate_xtce.sh ${PWD}/build/full/pc-linux/target/wh_defs.yaml ${PWD}/build/fixedwing/gemini2/cpd/target/wh_defs.db ${PWD}/build/fixedwing/gemini2/commander_workspace/mdb/cpd.xml


deploy::
	@if test -f "tools/git_tools/deploy.py"; then \
		if test ! -f "tools/git_tools/config.yaml"; then \
			echo '"tools/git_tools/config.yaml" not found. Using the template.'; \
			python3 tools/git_tools/deploy.py tools/git_tools/config-template.yaml || exit -1; \
			rc=$?; \
		else \
			python3 tools/git_tools/deploy.py tools/git_tools/config.yaml || exit -1; \
			rc=$?; \
		fi; \
		if [[ $rc -ne 0 ]]; then \
		    echo 'Deploy failed.                                                      '; \
		else \
		    rm tools/git_tools/deploy.py; \
		    echo '                                                                        '; \
		    echo 'Project is deployed.                                                    '; \
		    echo 'The deploy script is deleted to prevent accidental redeploy.            '; \
		    echo 'Check this newly created project into your own version control system.  '; \
		    echo '                                                                        '; \
		fi; \
	else \
		echo 'Project is already deployed and cannot be redeployed.                   '; \
		echo '                                                                        '; \
	fi
	

clean::
	@echo 'Cleaning flight software builds                                                 '
	rm -rf build
	
