#!/bin/bash
# MISC: I haven't find a way to fetch the built binary buildifier from the web.
#       Thus, a local copy is committed.
# Read https://github.com/bazelbuild/buildtools/tree/master/buildifier.
# TODO: Change to realpath.
./support/format/buildifier -r ./
