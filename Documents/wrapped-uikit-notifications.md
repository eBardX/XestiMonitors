# Wrapped UIKit Notifications

XestiMonitors provides numerous monitors wrapping the following `UIKit`
notifications:

 Notification Name                                  | Platform(s) | Monitor
:-------------------------------------------------- |:----------- |:-------
 `NSTextStorageDidProcessEditing`                   | iOS, tvOS   | [TextStorageMonitor][text_storage_monitor]
 `NSTextStorageWillProcessEditing`                  | iOS, tvOS   | [TextStorageMonitor][text_storage_monitor]
 `UIAccessibilityAnnouncementDidFinish`             | iOS, tvOS   | [AccessibilityAnnouncementMonitor][accessibility_announcement_monitor]
 `UIAccessibilityAssistiveTouchStatusDidChange`     | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityBoldTextStatusDidChange`           | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityClosedCaptioningStatusDidChange`   | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityDarkerSystemColorsStatusDidChange` | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityElementFocused`                    | iOS, tvOS   | [AccessibilityElementMonitor][accessibility_element_monitor]
 `UIAccessibilityGrayscaleStatusDidChange`          | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityGuidedAccessStatusDidChange`       | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityHearingDevicePairedEarDidChange`   | iOS         | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityInvertColorsStatusDidChange`       | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityMonoAudioStatusDidChange`          | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityReduceMotionStatusDidChange`       | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityReduceTransparencyStatusDidChange` | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityShakeToUndoDidChange`              | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilitySpeakScreenStatusDidChange`        | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilitySpeakSelectionStatusDidChange`     | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilitySwitchControlStatusDidChange`      | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIAccessibilityVoiceOverStatusDidChange`          | iOS, tvOS   | [AccessibilityStatusMonitor][accessibility_status_monitor]
 `UIApplicationBackgroundRefreshStatusDidChange`    | iOS         | [BackgroundRefreshMonitor][background_refresh_monitor]
 `UIApplicationDidBecomeActive`                     | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIApplicationDidChangeStatusBarFrame`             | iOS         | [StatusBarMonitor][status_bar_monitor]
 `UIApplicationDidChangeStatusBarOrientation`       | iOS         | [StatusBarMonitor][status_bar_monitor]
 `UIApplicationDidEnterBackground`                  | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIApplicationDidFinishLaunching`                  | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIApplicationDidReceiveMemoryWarning`             | iOS, tvOS   | [MemoryMonitor][memory_monitor]
 `UIApplicationProtectedDataDidBecomeAvailable`     | iOS, tvOS   | [ProtectedDataMonitor][protected_data_monitor]
 `UIApplicationProtectedDataWillBecomeUnavailable`  | iOS, tvOS   | [ProtectedDataMonitor][protected_data_monitor]
 `UIApplicationSignificantTimeChange`               | iOS, tvOS   | [TimeMonitor][time_monitor]
 `UIApplicationUserDidTakeScreenshot`               | iOS, tvOS   | [ScreenshotMonitor][screenshot_monitor]
 `UIApplicationWillChangeStatusBarFrame`            | iOS         | [StatusBarMonitor][status_bar_monitor]
 `UIApplicationWillChangeStatusBarOrientation`      | iOS         | [StatusBarMonitor][status_bar_monitor]
 `UIApplicationWillEnterForeground`                 | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIApplicationWillResignActive`                    | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIApplicationWillTerminate`                       | iOS, tvOS   | [ApplicationStateMonitor][application_state_monitor]
 `UIContentSizeCategoryDidChange`                   | iOS, tvOS   | [ContentSizeCategoryMonitor][content_size_category_monitor]
 `UIDeviceBatteryLevelDidChange`                    | iOS         | [BatteryMonitor][battery_monitor]
 `UIDeviceBatteryStateDidChange`                    | iOS         | [BatteryMonitor][battery_monitor]
 `UIDeviceOrientationDidChange`                     | iOS         | [OrientationMonitor][orientation_monitor]
 `UIDeviceProximityStateDidChange`                  | iOS         | [ProximityMonitor][proximity_monitor]
 `UIDocumentStateChanged`                           | iOS         | [DocumentStateMonitor][document_state_monitor]
 `UIFocusDidUpdate`                                 | iOS, tvOS   | [FocusMonitor][focus_monitor]
 `UIFocusMovementDidFail`                           | iOS, tvOS   | [FocusMonitor][focus_monitor]
 `UIKeyboardDidChangeFrame`                         | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIKeyboardDidHide`                                | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIKeyboardDidShow`                                | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIKeyboardWillChangeFrame`                        | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIKeyboardWillHide`                               | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIKeyboardWillShow`                               | iOS         | [KeyboardMonitor][keyboard_monitor]
 `UIMenuControllerDidHideMenu`                      | iOS         | [MenuControllerMonitor][menu_controller_monitor]
 `UIMenuControllerDidShowMenu`                      | iOS         | [MenuControllerMonitor][menu_controller_monitor]
 `UIMenuControllerMenuFrameDidChange`               | iOS         | [MenuControllerMonitor][menu_controller_monitor]
 `UIMenuControllerWillHideMenu`                     | iOS         | [MenuControllerMonitor][menu_controller_monitor]
 `UIMenuControllerWillShowMenu`                     | iOS         | [MenuControllerMonitor][menu_controller_monitor]
 `UIPasteboardChanged`                              | iOS         | [PasteboardMonitor][pasteboard_monitor]
 `UIPasteboardRemoved`                              | iOS         | [PasteboardMonitor][pasteboard_monitor]
 `UIScreenBrightnessDidChange`                      | iOS, tvOS   | [ScreenBrightnessMonitor][screen_brightness_monitor]
 `UIScreenCapturedDidChange`                        | iOS, tvOS   | [ScreenCapturedMonitor][screen_captured_monitor]
 `UIScreenDidConnect`                               | iOS, tvOS   | [ScreenConnectionMonitor][screen_connection_monitor]
 `UIScreenDidDisconnect`                            | iOS, tvOS   | [ScreenConnectionMonitor][screen_connection_monitor]
 `UIScreenModeDidChange`                            | iOS, tvOS   | [ScreenModeMonitor][screen_mode_monitor]
 `UITableViewSelectionDidChange`                    | iOS, tvOS   | [TableViewSelectionMonitor][table_view_selection_monitor]
 `UITextFieldTextDidBeginEditing`                   | iOS, tvOS   | [TextFieldTextMonitor][text_field_text_monitor]
 `UITextFieldTextDidChange`                         | iOS, tvOS   | [TextFieldTextMonitor][text_field_text_monitor]
 `UITextFieldTextDidEndEditing`                     | iOS, tvOS   | [TextFieldTextMonitor][text_field_text_monitor]
 `UITextInputCurrentInputModeDidChange`             | iOS, tvOS   | [TextInputModeMonitor][text_input_mode_monitor]
 `UITextViewTextDidBeginEditing`                    | iOS, tvOS   | [TextViewTextMonitor][text_view_text_monitor]
 `UITextViewTextDidChange`                          | iOS, tvOS   | [TextViewTextMonitor][text_view_text_monitor]
 `UITextViewTextDidEndEditing`                      | iOS, tvOS   | [TextViewTextMonitor][text_view_text_monitor]
 `UIViewControllerShowDetailTargetDidChange`        | iOS, tvOS   | [ViewControllerShowDetailTargetMonitor][view_controller_show_detail_target_monitor]
 `UIWindowDidBecomeHidden`                          | iOS, tvOS   | [WindowMonitor][window_monitor]
 `UIWindowDidBecomeKey`                             | iOS, tvOS   | [WindowMonitor][window_monitor]
 `UIWindowDidBecomeVisible`                         | iOS, tvOS   | [WindowMonitor][window_monitor]
 `UIWindowDidResignKey`                             | iOS, tvOS   | [WindowMonitor][window_monitor]

[accessibility_announcement_monitor]:           https://eBardX.github.io/XestiMonitors/Classes/AccessibilityAnnouncementMonitor.html
[accessibility_element_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/AccessibilityElementMonitor.html
[accessibility_status_monitor]:                 https://eBardX.github.io/XestiMonitors/Classes/AccessibilityStatusMonitor.html
[application_state_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/ApplicationStateMonitor.html
[background_refresh_monitor]:                   https://eBardX.github.io/XestiMonitors/Classes/BackgroundRefreshMonitor.html
[battery_monitor]:                              https://eBardX.github.io/XestiMonitors/Classes/BatteryMonitor.html
[content_size_category_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/ContentSizeCategoryMonitor.html
[document_state_monitor]:                       https://eBardX.github.io/XestiMonitors/Classes/DocumentStateMonitor.html
[focus_monitor]:                                https://eBardX.github.io/XestiMonitors/Classes/FocusMonitor.html
[keyboard_monitor]:                             https://eBardX.github.io/XestiMonitors/Classes/KeyboardMonitor.html
[memory_monitor]:                               https://eBardX.github.io/XestiMonitors/Classes/MemoryMonitor.html
[menu_controller_monitor]:                      https://eBardX.github.io/XestiMonitors/Classes/MenuControllerMonitor.html
[orientation_monitor]:                          https://eBardX.github.io/XestiMonitors/Classes/OrientationMonitor.html
[pasteboard_monitor]:                           https://eBardX.github.io/XestiMonitors/Classes/PasteboardMonitor.html
[protected_data_monitor]:                       https://eBardX.github.io/XestiMonitors/Classes/ProtectedDataMonitor.html
[proximity_monitor]:                            https://eBardX.github.io/XestiMonitors/Classes/ProximityMonitor.html
[screen_brightness_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/ScreenBrightnessMonitor.html
[screen_captured_monitor]:                      https://eBardX.github.io/XestiMonitors/Classes/ScreenCapturedMonitor.html
[screen_connection_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/ScreenConnectionMonitor.html
[screen_mode_monitor]:                          https://eBardX.github.io/XestiMonitors/Classes/ScreenModeMonitor.html
[screenshot_monitor]:                           https://eBardX.github.io/XestiMonitors/Classes/ScreenshotMonitor.html
[status_bar_monitor]:                           https://eBardX.github.io/XestiMonitors/Classes/StatusBarMonitor.html
[table_view_selection_monitor]:                 https://eBardX.github.io/XestiMonitors/Classes/TableViewSelectionMonitor.html
[text_field_text_monitor]:                      https://eBardX.github.io/XestiMonitors/Classes/TextFieldTextMonitor.html
[text_input_mode_monitor]:                      https://eBardX.github.io/XestiMonitors/Classes/TextInputModeMonitor.html
[text_storage_monitor]:                         https://eBardX.github.io/XestiMonitors/Classes/TextStorageMonitor.html
[text_view_text_monitor]:                       https://eBardX.github.io/XestiMonitors/Classes/TextViewTextMonitor.html
[time_monitor]:                                 https://eBardX.github.io/XestiMonitors/Classes/TimeMonitor.html
[view_controller_show_detail_target_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/ViewControllerShowDetailTargetMonitor.html
[window_monitor]:                               https://eBardX.github.io/XestiMonitors/Classes/WindowMonitor.html
