#!/usr/bin/env bash

set -e

VERSION=$(sed -En "/s.version[[:space:]]*=/s/^.*\\'(.*)\\'.*$/\1/gp" XestiMonitors.podspec)

if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    ref="v$VERSION"
else
    ref="$(git rev-parse HEAD)"
fi

jazzy --clean                                                                   \
      --github_url "https://github.com/eBardX/XestiMonitors"                    \
      --github-file-prefix "https://github.com/eBardX/XestiMonitors/tree/$ref"  \
      --module "XestiMonitors"                                                  \
      --module-version "$VERSION"                                               \
      --root-url "https://eBardX.github.io/XestiMonitors/reference/"            \
      --sdk iphoneos                                                            \
      --xcodebuild-arguments "-workspace,Example/XestiMonitors.xcworkspace,-scheme,XestiMonitors"
