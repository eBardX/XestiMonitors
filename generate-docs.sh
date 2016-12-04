#!/usr/bin/env bash

set -e

VERSION=$(sed -En "/s.version[[:space:]]*=/s/^.*\\'(.*)\\'.*$/\1/gp" XestiMonitors.podspec)

if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    REF="v$VERSION"
else
    REF="$(git rev-parse HEAD)"
fi

jazzy --clean                                                                   \
      --github-file-prefix "https://github.com/eBardX/XestiMonitors/tree/$REF"  \
      --module-version "$VERSION"                                               \
      --xcodebuild-arguments "-workspace,Example/XestiMonitors.xcworkspace,-scheme,XestiMonitors"
