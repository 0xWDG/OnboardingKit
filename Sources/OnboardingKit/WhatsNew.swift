//
//  WhatsNew.swift
//  OnboardingKit
//
//  Created by Wesley de Groot on 01/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/OnboardingKit
//  MIT LICENCE

import SwiftUI

/// What's new
/// 
/// A view to show the what's new screen.
@available(iOS 15.0, macOS 12.0, *)
struct WhatsNew: View {
    /// Should the view be shown
    @Binding
    var show: Bool

    /// What's new text
    var text: String

    /// Is the view dismissable
    var isDismissable: Bool = true

    /// Action to perform when the view is closed
    var closeAction: (() -> Void)?

    /// Helper class to get the App icon, name, version and build number.
    private let helper = OnboardingKitHelper()

    /// The view body
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                if let image = helper.getAppIcon() {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 82, height: 82)
                }

                VStack(alignment: .leading) {
                    Text(helper.getAppName())
                        .fontWeight(.bold)
                    Text("Version: \(helper.getVersionNumber())")
                        .foregroundStyle(.secondary)

                    Text("Build: \(helper.getBuildNumber())")
                        .foregroundStyle(.secondary)
                }
            }

            Text("What's new")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(14)

            ScrollView {
                VStack(spacing: 24) {
                    Text(.init(text))
                }
            }
            .padding(.leading)

            Spacer()

            Button(action: {
                self.closeAction?()
                self.show = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            })
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(15)
            .keyboardShortcut(isDismissable ? .defaultAction : .cancelAction)
        }
        .padding()
        .interactiveDismissDisabled(!isDismissable)
    }
}

struct WhatsNew_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNew(
            show: .constant(true),
            text: "This is some sample text, to show the what's new screen."
        )
    }
}
