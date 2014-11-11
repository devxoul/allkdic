#!/bin/bash

##
# The MIT License (MIT)
#
# Copyright (c) 2013-2014 Suyeol Jeon (http://xoul.kr)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

SRCROOT="Allkdic"
EXTENSIONS="h,m,swift"
MAX_LINE_LENGTH=119

ret=0
conditions=$(echo "$EXTENSIONS" | sed -E "s/(^,*|,*$)//g" | sed -E "s/([a-z]+)/-name \*\.\1/g" | sed "s/,/ -o /g")
files=$(find "$SRCROOT" \( $conditions \) -type f -not -wholename "*/*.framework/*")
for f in $files
do
    message=$(gawk -v len="$MAX_LINE_LENGTH" '{ if (length > len) print "    \x1b[31m" "\xe2\x9c\x97" "\033[0m", FILENAME, "at line", NR ":", "line too long (" length, ">", len ")" }' $f)
    if [ -n "$message" ]
    then
        echo "$message"
        ret=1
    fi
done

exit $ret
