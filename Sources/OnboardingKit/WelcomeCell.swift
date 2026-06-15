//
//  WelcomeCell.swift
//  OnboardingKit
//
//  Created by Wesley de Groot on 01/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/OnboardingKit
//  MIT LICENCE

import SwiftUI

/// WelcomeCell
/// 
/// A cell for the welcome screen.
@available(iOS 15.0, macOS 12.0, *)
public struct WelcomeCell: Identifiable, View {
    /// Stable identity for efficient list updates.
    public let id = UUID()

    /// SF Symbol name
    private let image: String

    /// Row title
    private let title: String

    /// Row subtitle
    private let subtitle: String

    /// SF Symbol color
    private let color: Color

    /// SF Symbol rendering mode
    private let renderingMode: Image.TemplateRenderingMode?

    /// WelcomeCell
    /// 
    /// Create a new WelcomeCell
    /// 
    /// - Parameters:
    ///   - image: SF Symbol name
    ///   - title: Row title
    ///   - subtitle: Row subtitle
    ///   - color: SF Symbol color (default: .accentColor)
    public init(
        image: String,
        title: String,
        subtitle: String,
        color: Color? = .accentColor
    ) {
        let helper = OnboardingKitHelper()
        self.image = helper.replaceVariables(in: image)
        self.title = helper.replaceVariables(in: title)
        self.subtitle = helper.replaceVariables(in: subtitle)
        self.color = color ?? .accentColor
        self.renderingMode = color == nil ? nil : .template
    }

    /// The view body
    public var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
                .renderingMode(renderingMode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(color)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.primary)
                    .font(.headline)

                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding()
#if !os(visionOS)
        .background(.thickMaterial)
#endif
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    WelcomeCell(
        image: "text.badge.checkmark",
        title: "Title",
        subtitle: "Subtitle",
        color: .blue
    )
}
