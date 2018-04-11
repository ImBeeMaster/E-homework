#!/bin/sed -f
## remove one-line comments from C/C++ code
/^[^'"]*\/\//s/\/\/.*$/ /g
