# Wrapped Foundation Notifications

XestiMonitors provides several monitors wrapping the following `Foundation`
notifications:

Notification Name                                           | Platform(s)               | Monitor
:---------------------------------------------------------- |:------------------------- |:-------
`Bundle.didLoadNotification`                                | iOS, macOS, tvOS, watchOS | [BundleClassLoadMonitor][bundle_class_load_monitor]
`FileHandle.readCompletionNotification`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSBundleResourceRequestLowDiskSpace`                       | iOS,        tvOS, watchOS | [BundleResourceRequestMonitor][bundle_resource_request_monitor]
`NSCalendarDayChanged`                                      | iOS, macOS, tvOS, watchOS | CalendarDayMonitor (_see_ [#55](https://github.com/eBardX/XestiMonitors/issues/55))
`NSDidBecomeSingleThreaded`                                 | iOS, macOS, tvOS, watchOS | _Will not implement_
`NSExtensionHostDidBecomeActive`                            | iOS,        tvOS, watchOS | [ExtensionHostMonitor][extension_host_monitor]
`NSExtensionHostDidEnterBackground`                         | iOS,        tvOS, watchOS | [ExtensionHostMonitor][extension_host_monitor]
`NSExtensionHostWillEnterForeground`                        | iOS,        tvOS, watchOS | [ExtensionHostMonitor][extension_host_monitor]
`NSExtensionHostWillResignActive`                           | iOS,        tvOS, watchOS | [ExtensionHostMonitor][extension_host_monitor]
`NSFileHandleConnectionAccepted`                            | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleDataAvailable`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleReadToEndOfFileCompletion`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerAcceptPolicyChanged`                    | iOS, macOS, tvOS, watchOS | [HTTPCookieStorageMonitor][http_cookie_storage_monitor]
`NSHTTPCookieManagerCookiesChanged`                         | iOS, macOS, tvOS, watchOS | [HTTPCookieStorageMonitor][http_cookie_storage_monitor]
`NSLocale.currentLocaleDidChangeNotification`               | iOS, macOS, tvOS, watchOS | CurrentLocaleMonitor (_see_ [#56](https://github.com/eBardX/XestiMonitors/issues/56))
`NSMetadataQueryDidFinishGathering`                         | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidStartGathering`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidUpdate`                                  | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryGatheringProgress`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSProcessInfoPowerStateDidChange`                          | iOS,        tvOS, watchOS | [ProcessInfoPowerStateMonitor][process_info_power_state_monitor]
`NSSystemClockDidChange`                                    | iOS, macOS, tvOS, watchOS | SystemClockMonitor (_see_ [#53](https://github.com/eBardX/XestiMonitors/issues/53))
`NSSystemTimeZoneDidChange`                                 | iOS, macOS, tvOS, watchOS | [SystemTimeZoneMonitor][system_time_zone_monitor]
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

[bundle_class_load_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/BundleClassLoadMonitor.html
[bundle_resource_request_monitor]:      https://eBardX.github.io/XestiMonitors/Classes/BundleResourceRequestMonitor.html
[extension_host_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/ExtensionHostMonitor.html
[http_cookie_storage_monitor]:          https://eBardX.github.io/XestiMonitors/Classes/HTTPCookieStorageMonitor.html
[metadata_query_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/MetadataQueryMonitor.html
[port_monitor]:                         https://eBardX.github.io/XestiMonitors/Classes/PortMonitor.html
[process_info_power_state_monitor]:     https://eBardX.github.io/XestiMonitors/Classes/ProcessInfoPowerStateMonitor.html
[process_info_thermal_state_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/ProcessInfoThermalStateMonitor.html
[system_time_zone_monitor]:             https://eBardX.github.io/XestiMonitors/Classes/SystemTimeZoneMonitor.html
[ubiquitous_key_value_store_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/UbiquitousKeyValueStoreMonitor.html
[ubiquity_identity_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/UbiquityIdentityMonitor.html
[undo_manager_monitor]:                 https://eBardX.github.io/XestiMonitors/Classes/UndoManagerMonitor.html
[user_defaults_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/UserDefaultsMonitor.html

