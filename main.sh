#!/bin/sh

if [ "$1" != "" ]; then
    # Run shell command and exit
    /bin/sh -c "$*"
    exit $?
fi

TEMP_DIR=/tmp/php-builder
GIT_VER_DEF=master

print () {
    echo -en "\033[1;36m"; echo -n "$*"; echo -en "\033[0m"; echo ""
}
print_err () {
    echo -en "\033[37;1;41m"; echo -n "ERROR:  $*"; echo -en "\033[0m"; echo ""
}

print_help () {
    echo -en "\033[1;36m"
    cat << EOF

Download and build php extension from source codes.
The results saved into the folder '/build'.

USAGE:
    docker run --rm \\
        -v /\`pwd\`/build:/build \\
        -e "GIT_REPO=<url>" \\
        -e "GIT_VER=<tag|branch>" \\
        chazer/alpine-php-builder
or
    docker run --rm \\
        chazer/alpine-php-builder <command>
EOF
    echo -en "\033[0m"
}

if [ "$GIT_REPO" == "" ]; then
    print_err "Repository URL  is not specified"
    print_help
    exit 1
fi

if [ "$GIT_VER" == "" ]; then
    print "Version is not specified. Set to the '$GIT_VER_DEF'"
    GIT_VER="$GIT_VER_DEF"
fi

rm -rf "$TEMP_DIR"

print "> Clone repository $GIT_REPO" >&2
git clone $GIT_REPO "$TEMP_DIR"
if [ $? -ne 0 ] ; then print_err "Cloning fails" >&2; exit 2; fi
cd "$TEMP_DIR"

print "> Checkout version $GIT_VER" >&2
git checkout $GIT_VER
if [ $? -ne 0 ] ; then print_err "Checkout fails" >&2; exit 2; fi

phpize

print "> Configure module" >&2
./configure $*
if [ $? -ne 0 ] ; then print_err "Configure fails" >&2; exit 3; fi

print "> Build module" >&2
make
if [ $? -ne 0 ] ; then print_err "Make fails" >&2; exit 4; fi

print "> Test module" >&2
make test
if [ $? -ne 0 ] ; then print_err "Test fails" >&2; exit 4; fi

# make succeeds
cp modules/*.so /build
rm -rf "$TEMP_DIR"
ls -la /build

print "> Done" >&2
exit 0
