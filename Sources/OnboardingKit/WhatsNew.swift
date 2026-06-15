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
public struct WhatsNew: View {
    /// Should the view be shown
    @Binding private var show: Bool

    /// What's new text
    private let text: String

    /// Action to perform when the view is closed
    private let closeAction: (() -> Void)?

    /// Can we continue?
    @State private var canContinue: Bool

    /// Helper class to get the App icon, name, version and build number.
    private let helper = OnboardingKitHelper()

    /// What's new
    ///
    /// A view to show the what's new screen.
    ///
    /// - Parameters:
    ///   - show: Is the view shown
    ///   - text: Text to show
    ///   - isDismissable: is dismissable
    ///   - closeAction: action to run on dismiss
    public init(
        show: Binding<Bool>,
        text: String,
        isDismissable: Bool = false,
        closeAction: (() -> Void)? = nil
    ) {
        self._show = show
        self.text = text
        self.closeAction = closeAction
        self._canContinue = State(initialValue: isDismissable)
    }
    /// The view body
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                helper.appIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(width: 82, height: 82)
                    .accessibilityHidden(true)

                VStack(alignment: .leading) {
                    Text(helper.appName)
                        .fontWeight(.bold)
                    Text("Version: \(helper.versionNumber) (\(helper.buildNumber))", bundle: .module)
                        .foregroundStyle(.secondary)
                }
            }

            Text("What's new", bundle: .module)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(14)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text(.init(text))
                    Color.clear
                        .frame(height: 1)
                        .accessibilityHidden(true)
                        .onAppear {
                            canContinue = true
                        }
                }
            }
            .padding(.horizontal)

            Spacer()

            OnboardingContinueButton(isEnabled: canContinue, action: dismiss)
        }
        .padding()
        .interactiveDismissDisabled(!canContinue)
    }

    private func dismiss() {
        closeAction?()
        show = false
    }
}

#Preview {
    WhatsNew(
        show: .constant(true),
        text: "This is some sample text, to show the what's new screen."
    )
}
