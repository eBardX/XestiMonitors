# Wrapped Foundation Notifications

XestiMonitors provides several monitors wrapping the following `Foundation`
notifications:

Notification Name                                           | Platform(s)               | Monitor
:---------------------------------------------------------- |:------------------------- |:-------
`Bundle.didLoadNotification`                                | iOS, macOS, tvOS, watchOS | BundleClassLoadMonitor (_see_ [#59](https://github.com/eBardX/XestiMonitors/issues/59))
`FileHandle.readCompletionNotification`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSBundleResourceRequestLowDiskSpace`                       | iOS,        tvOS, watchOS | BundleResourceRequestMonitor (_see_ [#58](https://github.com/eBardX/XestiMonitors/issues/58))
`NSCalendarDayChanged`                                      | iOS, macOS, tvOS, watchOS | CalendarDayMonitor (_see_ [#55](https://github.com/eBardX/XestiMonitors/issues/55))
`NSDidBecomeSingleThreaded`                                 | iOS, macOS, tvOS, watchOS | _Will not implement_
`NSExtensionHostDidBecomeActive`                            | iOS,        tvOS, watchOS | ExtensionHostMonitor (_see_ [#48](https://github.com/eBardX/XestiMonitors/issues/48))
`NSExtensionHostDidEnterBackground`                         | iOS,        tvOS, watchOS | ExtensionHostMonitor (_see_ [#48](https://github.com/eBardX/XestiMonitors/issues/48))
`NSExtensionHostWillEnterForeground`                        | iOS,        tvOS, watchOS | ExtensionHostMonitor (_see_ [#48](https://github.com/eBardX/XestiMonitors/issues/48))
`NSExtensionHostWillResignActive`                           | iOS,        tvOS, watchOS | ExtensionHostMonitor (_see_ [#48](https://github.com/eBardX/XestiMonitors/issues/48))
`NSFileHandleConnectionAccepted`                            | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleDataAvailable`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleReadToEndOfFileCompletion`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerAcceptPolicyChanged`                    | iOS, macOS, tvOS, watchOS | HTTPCookieStorageMonitor (_see_ [#49](https://github.com/eBardX/XestiMonitors/issues/49))
`NSHTTPCookieManagerCookiesChanged`                         | iOS, macOS, tvOS, watchOS | HTTPCookieStorageMonitor (_see_ [#49](https://github.com/eBardX/XestiMonitors/issues/49))
`NSLocale.currentLocaleDidChangeNotification`               | iOS, macOS, tvOS, watchOS | CurrentLocaleMonitor (_see_ [#56](https://github.com/eBardX/XestiMonitors/issues/56))
`NSMetadataQueryDidFinishGathering`                         | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidStartGathering`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidUpdate`                                  | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryGatheringProgress`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSProcessInfoPowerStateDidChange`                          | iOS,        tvOS, watchOS | [ProcessInfoPowerStateMonitor][process_info_power_state_monitor]
`NSSystemClockDidChange`                                    | iOS, macOS, tvOS, watchOS | SystemClockMonitor (_see_ [#53](https://github.com/eBardX/XestiMonitors/issues/53))
`NSSystemTimeZoneDidChange`                                 | iOS, macOS, tvOS, watchOS | SystemTimeZoneMonitor (_see_ [#54](https://github.com/eBardX/XestiMonitors/issues/54))
`NSThreadWillExit`                                          | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUbiquitousKeyValueStore.didChangeExternallyNotification` | iOS, macOS, tvOS          | [UbiquitousKeyValueStoreMonitor][ubiquitous_key_value_store_monitor]
`NSUbiquityIdentityDidChange`                               | iOS, macOS, tvOS, watchOS | [UbiquityIdentityMonitor][ubiquity_identity_monitor]
`NSUndoManagerCheckpoint`                                   | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerDidCloseUndoGroup`                            | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerDidOpenUndoGroup`                             | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerDidRedoChange`                                | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerDidUndoChange`                                | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerWillCloseUndoGroup`                           | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerWillRedoChange`                               | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSUndoManagerWillUndoChange`                               | iOS, macOS, tvOS, watchOS | [UndoManagerMonitor][undo_manager_monitor]
`NSURLCredentialStorageChanged`                             | iOS, macOS, tvOS, watchOS | URLCredentialStorageMonitor (_see_ [#50](https://github.com/eBardX/XestiMonitors/issues/50))
`NSWillBecomeMultiThreaded`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`Port.didBecomeInvalidNotification`                         | iOS, macOS, tvOS, watchOS | [PortMonitor][port_monitor]
`ProcessInfo.thermalStateDidChangeNotification`             | iOS, macOS, tvOS, watchOS | [ProcessInfoThermalStateMonitor][process_info_thermal_state_monitor]
`UserDefaults.completedInitialCloudSyncNotification`        | iOS,        tvOS, watchOS | UbiquitousUserDefaultsMonitor (_see_ [#60](https://github.com/eBardX/XestiMonitors/issues/60))
`UserDefaults.didChangeCloudAccountsNotification`           | iOS,        tvOS, watchOS | UbiquitousUserDefaultsMonitor (_see_ [#60](https://github.com/eBardX/XestiMonitors/issues/60))
`UserDefaults.didChangeNotification`                        | iOS, macOS, tvOS, watchOS | [UserDefaultsMonitor][user_defaults_monitor]
`UserDefaults.noCloudAccountNotification`                   | iOS,        tvOS, watchOS | UbiquitousUserDefaultsMonitor (_see_ [#60](https://github.com/eBardX/XestiMonitors/issues/60))
`UserDefaults.sizeLimitExceededNotification`                | iOS,        tvOS, watchOS | [UserDefaultsMonitor][user_defaults_monitor]

[metadata_query_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/MetadataQueryMonitor.html
[port_monitor]:                         https://eBardX.github.io/XestiMonitors/Classes/PortMonitor.html
[process_info_power_state_monitor]:     https://eBardX.github.io/XestiMonitors/Classes/ProcessInfoPowerStateMonitor.html
[process_info_thermal_state_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/ProcessInfoThermalStateMonitor.html
[ubiquitous_key_value_store_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/UbiquitousKeyValueStoreMonitor.html
[ubiquity_identity_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/UbiquityIdentityMonitor.html
[undo_manager_monitor]:                 https://eBardX.github.io/XestiMonitors/Classes/UndoManagerMonitor.html
[user_defaults_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/UserDefaults.html

