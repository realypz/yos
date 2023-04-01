#!/bin/bash
# MISC: -style=file will try to find the .clang-format file
#       located in the closest parent directory of the input file
#       to be formatted.
#       Thus, `.clang-format` is enforced to locate at the repo root.
# Read https://releases.llvm.org/3.6.0/tools/clang/docs/ClangFormatStyleOptions.html
find . -iname *.h -o -iname *.hpp -o -iname *.c -o -iname *.cpp | xargs clang-format -i -style=file
