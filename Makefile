SHELL := /bin/bash

TARDIGRADE_CI_ORG := lorengordon
TARDIGRADE_CI_BRANCH := feat/prefer-moto-server

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)
