// swift-tools-version:4.0

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
                                          targets: ["XestiMonitors"])],
                      dependencies: [],
                      targets: [.target(name: "XestiMonitors",
                                        dependencies: [],
                                        path: ".",
                                        exclude: ["*.h", "*.m"],
                                        sources: ["Sources/Core"])],
                      swiftLanguageVersions: [4])
