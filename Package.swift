//
//  Package.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-10.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import PackageDescription

let package = Package(name: "XestiMonitors",
                      products: [.library(name: "XestiMonitors",
                                          type: .dynamic,
                                          targets: ["XestiMonitors"])],
                      dependencies: [],
                      targets: [.target(name: "XestiMonitors",
                                        dependencies: [],
                                        path: "Sources/Core"),
                                .testTarget(name: "XestiMonitorsTests",
                                            dependencies: ["XestiMonitors"],
                                            path: "Tests")],
                      swiftLanguageVersions: [4])
