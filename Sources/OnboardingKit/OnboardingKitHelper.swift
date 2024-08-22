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
    public func getAppName() -> String {
        dump(Bundle.main.infoDictionary)

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
    public func getVersionNumber() -> String {
        if let dictionary = Bundle.main.infoDictionary,
           let dVersion = dictionary["CFBundleShortVersionString"] as? String {
            return dVersion
        }

        return "0"
    }

    /// Get application build number
    /// - Returns: application build number
    public func getBuildNumber() -> String {
        if let dictionary = Bundle.main.infoDictionary,
           let dBuild = dictionary["CFBundleVersion"] as? String {
            return dBuild
        }

        return "0"
    }

    /// Get application icon
    /// - Returns: Application icon
    public func getAppIcon() -> Image {
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
            .replacingOccurrences(of: "%APP_NAME%", with: getAppName())
            .replacingOccurrences(of: "%APP_VERSION%", with: getVersionNumber())
            .replacingOccurrences(of: "%APP_BUILD%", with: getBuildNumber())
    }
}
