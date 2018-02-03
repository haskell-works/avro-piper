#!/bin/bash

stack build

exe=$(cat $(basename $PWD).cabal | grep executable | head -n 1 | cut -d' ' -f2)
path=$(stack path --local-install-root)

${path}/bin/${exe} $@
