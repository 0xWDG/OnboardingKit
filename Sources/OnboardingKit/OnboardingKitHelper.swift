//
//  OnboardingKitHelper.swift
//  OnboardingKit
//
//  Created by Wesley de Groot on 01/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/OnboardingKit
//  MIT LICENCE

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

/// OnboardingKit helper class
package class OnboardingKitHelper {

    /// OnboardingKit helper class
    public init() {

    }

    /// Get application name
    /// - Returns: application name
    public var appName: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dName = dictionary["CFBundleDisplayName"] as? String {
            return dName
        }

        if let dictionary = Bundle.main.infoDictionary,
           let dName = dictionary["CFBundleName"] as? String {
            return dName
        }

        return "Unknown"
    }

    /// Get application version number
    /// - Returns: application version number
    public var versionNumber: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dVersion = dictionary["CFBundleShortVersionString"] as? String {
            return dVersion
        }

        return "0"
    }

    /// Get application build number
    /// - Returns: application build number
    public var buildNumber: String {
        if let dictionary = Bundle.main.infoDictionary,
           let dBuild = dictionary["CFBundleVersion"] as? String {
            return dBuild
        }

        return "0"
    }

    /// Get application icon
    /// - Returns: Application icon
    public var appIcon: Image {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }

#if canImport(UIKit)
        guard let uiImage = UIImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(uiImage: uiImage)
#elseif canImport(AppKit)
        guard let nsImage = NSImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(nsImage: nsImage)
#else
        return Image(systemName: "xmark.app")
#endif
    }

    private var deviceType: String {
#if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? "ipad" : "iphone"
#elseif os(macOS)
        return  "macbook"
#elseif os(visionOS)
        return "visionpro"
#elseif os(tvOS)
        return "appletv"
#elseif os(watchOS)
        return "applewatch"
#endif
    }

    private var deviceTypeApps: String {
#if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? "apps.ipad" : "apps.iphone"
#elseif os(macOS)
        return  "macbook"
#elseif os(visionOS)
        return "visionpro"
#elseif os(tvOS)
        return "appletv"
#elseif os(watchOS)
        return "applewatch"
#endif
    }

    /// Replace variables in a string
    ///
    /// Supported variables:
    /// - %APP_NAME%: Application name
    /// - %APP_VERSION%: Application version number
    /// - %APP_BUILD%: Application build number
    ///
    /// - Parameter string: Input string
    /// - Returns: Transformed string
    public func replaceVariables(in string: String) -> String {
        return string
            .replacingOccurrences(of: "%DEVICE_APPS%", with: deviceTypeApps)
            .replacingOccurrences(of: "%DEVICE_TYPE%", with: deviceType)
            .replacingOccurrences(of: "%APP_NAME%", with: appName)
            .replacingOccurrences(of: "%APP_VERSION%", with: versionNumber)
            .replacingOccurrences(of: "%APP_BUILD%", with: buildNumber)
    }
}
