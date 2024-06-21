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
public struct WelcomeCell: View {

    /// SF Symbol name
    var image: String

    /// Row title
    var title: String

    /// Row subtitle
    var subtitle: String

    /// SF Symbol color
    var color: Color = .accentColor

    /// SF Symbol rendering mode
    var renderingMode: Image.TemplateRenderingMode?

    /// Helper class to replace variables
    let helper = OnboardingKitHelper()

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
        self.image = image
        self.title = title
        self.subtitle = subtitle

        if let color = color {
            self.color = color
            self.renderingMode = .template
        }
    }

    /// The view body
    public var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
                .renderingMode(renderingMode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(.init(helper.replaceVariables(in: title)))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(.init(helper.replaceVariables(in: subtitle)))
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }

            Spacer()
        }
    }
}

struct OnboardingCell_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeCell(
            image: "text.badge.checkmark",
            title: "Title",
            subtitle: "Subtitle",
            color: .blue
        )
    }
}
