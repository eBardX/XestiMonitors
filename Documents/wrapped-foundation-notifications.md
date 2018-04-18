# Wrapped Foundation Notifications

XestiMonitors provides several monitors wrapping the following `Foundation`
notifications:

Notification Name                              | Platform(s)               | Monitor
:--------------------------------------------- |:------------------------- |:-------
`NSAppleEventManagerWillProcessFirstEvent`     |      macOS                | _Not yet implemented_
`NSBundleDidLoad`                              | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSBundleResourceRequestLowDiskSpace`          | iOS,        tvOS, watchOS | _Not yet implemented_
`NSCalendarDayChanged`                         | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSCurrentLocaleDidChange`                     | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSDidBecomeSingleThreaded`                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleConnectionAccepted`               | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleDataAvailable`                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleReadCompletion`                   | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSFileHandleReadToEndOfFileCompletion`        | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerAcceptPolicyChanged`       | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSHTTPCookieManagerCookiesChanged`            | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSMetadataQueryDidFinishGathering`            | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidStartGathering`             | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryDidUpdate`                     | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSMetadataQueryGatheringProgress`             | iOS, macOS, tvOS, watchOS | [MetadataQueryMonitor][metadata_query_monitor]
`NSPortDidBecomeInvalid`                       | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSProcessInfoPowerStateDidChange`             | iOS,        tvOS, watchOS | _Not yet implemented_
`NSProcessInfoThermalStateDidChange`           | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSSystemClockDidChange`                       | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSSystemTimeZoneDidChange`                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSTaskDidTerminate`                           |      macOS                | _Not yet implemented_
`NSTextStorageDidProcessEditing`               | iOS, macOS, tvOS          | _Not yet implemented_
`NSTextStorageWillProcessEditing`              | iOS, macOS, tvOS          | _Not yet implemented_
`NSThreadWillExit`                             | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUbiquitousKeyValueStoreDidChangeExternally` | iOS, macOS, tvOS          | [UbiquitousKeyValueStoreMonitor][ubiquitous_key_value_store_monitor]
`NSUbiquitousUserDefaultsCompletedInitialSync` | iOS,        tvOS, watchOS | _Not yet implemented_
`NSUbiquitousUserDefaultsDidChangeAccounts`    | iOS,        tvOS, watchOS | _Not yet implemented_
`NSUbiquitousUserDefaultsNoCloudAccount`       | iOS,        tvOS, watchOS | _Not yet implemented_
`NSUbiquityIdentityDidChange`                  | iOS, macOS, tvOS, watchOS | [UbiquityIdentityMonitor][ubiquity_identity_monitor]
`NSUndoManagerCheckpoint`                      | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerDidCloseUndoGroup`               | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerDidOpenUndoGroup`                | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerDidRedoChange`                   | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerDidUndoChange`                   | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerWillCloseUndoGroup`              | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerWillRedoChange`                  | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUndoManagerWillUndoChange`                  | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSURLCredentialStorageChanged`                | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUserDefaultsDidChange`                      | iOS, macOS, tvOS, watchOS | _Not yet implemented_
`NSUserDefaultsSizeLimitExceeded`              | iOS,        tvOS, watchOS | _Not yet implemented_
`NSWillBecomeMultiThreaded`                    | iOS, macOS, tvOS, watchOS | _Not yet implemented_

[metadata_query_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/MetadataQueryMonitor.html
[ubiquitous_key_value_store_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/UbiquitousKeyValueStoreMonitor.html
[ubiquity_identity_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/UbiquityIdentityMonitor.html
