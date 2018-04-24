# Wrapped Foundation Notifications

XestiMonitors provides several monitors wrapping the following `Foundation`
notifications:

Notification Name                                           | Platform(s)               | Monitor
:---------------------------------------------------------- |:------------------------- |:-------
`Bundle.didLoadNotification`                                | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`FileHandle.readCompletionNotification`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSBundleResourceRequestLowDiskSpace`                       | iOS,        tvOS, watchOS | _Not yet implemented_
`NSCalendarDayChanged`                                      | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSDidBecomeSingleThreaded`                                 | iOS, macOS, tvOS, watchOS | _Will not implement_
`NSExtensionHostDidBecomeActive`                            | iOS,        tvOS, watchOS | _Not yet implemented_
`NSExtensionHostDidEnterBackground`                         | iOS,        tvOS, watchOS | _Not yet implemented_
`NSExtensionHostWillEnterForeground`                        | iOS,        tvOS, watchOS | _Not yet implemented_
`NSExtensionHostWillResignActive`                           | iOS,        tvOS, watchOS | _Not yet implemented_
`NSFileHandleConnectionAccepted`                            | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleDataAvailable`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleReadToEndOfFileCompletion`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerAcceptPolicyChanged`                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerCookiesChanged`                         | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSLocale.currentLocaleDidChangeNotification`               | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSMetadataQueryDidFinishGathering`                         | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidStartGathering`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidUpdate`                                  | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryGatheringProgress`                          | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSProcessInfoPowerStateDidChange`                          | iOS,        tvOS, watchOS | _Not yet implemented_
`NSSystemClockDidChange`                                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSSystemTimeZoneDidChange`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSThreadWillExit`                                          | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUbiquitousKeyValueStore.didChangeExternallyNotification` | iOS, macOS, tvOS          | [UbiquitousKeyValueStoreMonitor][ubiquitous_key_value_store_monitor]
`NSUbiquityIdentityDidChange`                               | iOS, macOS, tvOS, watchOS | [UbiquityIdentityMonitor][ubiquity_identity_monitor]
`NSUndoManagerCheckpoint`                                   | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerDidCloseUndoGroup`                            | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerDidOpenUndoGroup`                             | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerDidRedoChange`                                | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerDidUndoChange`                                | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerWillCloseUndoGroup`                           | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerWillRedoChange`                               | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSUndoManagerWillUndoChange`                               | iOS, macOS, tvOS, watchOS | UndoManagerMonitor (_see_ [#41](https://github.com/eBardX/XestiMonitors/issues/41))
`NSURLCredentialStorageChanged`                             | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSWillBecomeMultiThreaded`                                 | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`Port.didBecomeInvalidNotification`                         | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`ProcessInfo.thermalStateDidChangeNotification`             | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`UserDefaults.completedInitialCloudSyncNotification`        | iOS,        tvOS, watchOS | UserDefaultsMonitor (_see_ [#44](https://github.com/eBardX/XestiMonitors/issues/44))
`UserDefaults.didChangeCloudAccountsNotification`           | iOS,        tvOS, watchOS | UserDefaultsMonitor (_see_ [#44](https://github.com/eBardX/XestiMonitors/issues/44))
`UserDefaults.didChangeNotification`                        | iOS, macOS, tvOS, watchOS | UserDefaultsMonitor (_see_ [#44](https://github.com/eBardX/XestiMonitors/issues/44))
`UserDefaults.noCloudAccountNotification`                   | iOS,        tvOS, watchOS | UserDefaultsMonitor (_see_ [#44](https://github.com/eBardX/XestiMonitors/issues/44))
`UserDefaults.sizeLimitExceededNotification`                | iOS,        tvOS, watchOS | UserDefaultsMonitor (_see_ [#44](https://github.com/eBardX/XestiMonitors/issues/44))

[metadata_query_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/MetadataQueryMonitor.html
[ubiquitous_key_value_store_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/UbiquitousKeyValueStoreMonitor.html
[ubiquity_identity_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/UbiquityIdentityMonitor.html
