#!/bin/sh

# Copyright © 2021 Yegor Bychin <j@siga.icu>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

command -v xclip >/dev/null 2>&1 || { echo "error: need xclip" >&2; exit 2; }

case $# in
    0)
        echo "error: no arguments"
        exit 1
        ;;
    1)
        # copy file by its content (mime-type is guessed using `file`)
        [ -f "$1" ] || { echo "error: $1 is not a file." >&2; exit 1; }
        mime_type=$(file -b --mime-type "$1")
        xclip -selection clipboard -t "$mime_type" < "$1"
        ;;
    *)
        # GNU `realpath` prints full paths of passed files on new line
        paths=$(realpath "$@")
        [ $? -eq 0 ] || { exit 10; }

        # then `sed` appends 'file://' to each line
        uri_list=$(printf "$paths" | sed  "s/^/file:\/\//")

        # copy list of URIs of files into clipboard with mime-type 'text/uri-list'
        echo "$uri_list" | xclip -selection clipboard -t "text/uri-list"
        ;;
esac
