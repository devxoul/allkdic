MAX_LINE_LENGTH=119

MSG=$(find Allkdic \( -name "*.h" -o -name "*.m" -o -name "*.swift" ! -name "*.framework" \) -type f -not -wholename "*/*.framework/*" |\
      xargs awk -v len="$MAX_LINE_LENGTH" '{ if (length > len) print "\t\x1b[31m" "\xe2\x9c\x97" "\033[0m", FILENAME, "at line", NR ":", "line too long (" length, ">", len ")" }')
if [ MSG == 0 ]
then
    exit 0
else
    echo "$MSG"
    exit 1
fi
