MPOD2HTML=`which mpod2html`

test ! -z ${MPOD2HTML} || {
        echo "Unable to find mpod2html in the \$PATH";
        exit 1
}

${MPOD2HTML} blib/lib \
        -dir html/ \
        -nobanner \
        -nowarnings \
        -noverbose \
        -idxname "idx" \
        -tocname "index" \
        -toctitle "Clutter-Perl - Table of Contents" \
        -idxtitle "Clutter-Perl Index" \
        > /dev/null 2>&1
