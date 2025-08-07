// swift-tools-version: 5.10

// © 2018–2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiMonitors",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14),
                                  .tvOS(.v16),
                                  .watchOS(.v9)],
                      products: [.library(name: "XestiMonitors",
                                          targets: ["XestiMonitors"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiTools.git",
                                              from: "4.0.0")],
                      targets: [.target(name: "XestiMonitors",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .testTarget(name: "XestiMonitorsTests",
                                            dependencies: [.target(name: "XestiMonitors")])],
                      swiftLanguageVersions: [.v5])

let swiftSettings: [SwiftSetting] = [.enableUpcomingFeature("BareSlashRegexLiterals"),
                                     .enableUpcomingFeature("ConciseMagicFile"),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ForwardTrailingClosures"),
                                     .enableUpcomingFeature("ImplicitOpenExistentials")]

for target in package.targets {
    var settings = target.swiftSettings ?? []

    settings.append(contentsOf: swiftSettings)

    target.swiftSettings = settings
}
