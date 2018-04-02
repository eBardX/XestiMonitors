#!/usr/bin/env bash

set -e

if (( $# != 0 )); then
echo "Usage: generate-docs.sh" 1>&2
exit 1
fi

SCRIPTS_DIR=$(unset CDPATH && cd "${0%/*}" &>/dev/null && pwd)

cd "$SCRIPTS_DIR"/..

VERSION=$(sed -En "/s.version[[:space:]]*=/s/^.*\\'(.*)\\'.*$/\1/gp" XestiMonitors.podspec)

if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    REF="v$VERSION"
else
    REF="$(git rev-parse HEAD)"
fi

jazzy --clean                                                                   \
      --github-file-prefix "https://github.com/eBardX/XestiMonitors/tree/$REF"  \
      --module-version "$VERSION"                                               \
      --xcodebuild-arguments "-project,XestiMonitors.xcodeproj,-scheme,XestiMonitors-iOS"
