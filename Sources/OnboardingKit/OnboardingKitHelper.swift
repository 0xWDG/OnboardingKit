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

/// OnboardingKit helper class
struct OnboardingKitHelper {
    let appName: String
    let versionNumber: String
    let buildNumber: String

    /// OnboardingKit helper class
    init(bundle: Bundle = .main) {
        let information = bundle.infoDictionary ?? [:]
        appName = information["CFBundleDisplayName"] as? String
            ?? information["CFBundleName"] as? String
            ?? "Unknown"
        versionNumber = information["CFBundleShortVersionString"] as? String ?? "0"
        buildNumber = information["CFBundleVersion"] as? String ?? "0"
        iconFileName = Self.iconFileName(in: information)
    }

    private let iconFileName: String?

    /// Get application icon
    /// - Returns: Application icon
    var appIcon: Image {
#if canImport(UIKit)
        guard let iconFileName, let image = UIImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(uiImage: image)
#elseif canImport(AppKit)
        guard let iconFileName, let image = NSImage(named: iconFileName) else {
            return Image(systemName: "xmark.app")
        }

        return Image(nsImage: image)
#else
        return Image(systemName: "xmark.app")
#endif
    }

    private var deviceType: String {
#if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? "ipad" : "iphone"
#elseif os(macOS)
        return "macbook"
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
        return "macbook"
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
    func replaceVariables(in string: String) -> String {
        string
            .replacingOccurrences(of: "%DEVICE_APPS%", with: deviceTypeApps)
            .replacingOccurrences(of: "%DEVICE_TYPE%", with: deviceType)
            .replacingOccurrences(of: "%APP_NAME%", with: appName)
            .replacingOccurrences(of: "%APP_VERSION%", with: versionNumber)
            .replacingOccurrences(of: "%APP_BUILD%", with: buildNumber)
    }

    private static func iconFileName(in information: [String: Any]) -> String? {
        if let icons = information["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String] {
            return iconFiles.last
        }

        return information["CFBundleIconFile"] as? String
    }
}
