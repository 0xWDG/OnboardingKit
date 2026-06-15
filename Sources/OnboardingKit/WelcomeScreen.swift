//
//  WelcomeScreen.swift
//  OnboardingKit
//
//  Created by Wesley de Groot on 01/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/OnboardingKit
//  MIT LICENCE

import SwiftUI

/// WelcomeScreen
///
/// The welcome screen for your app.
@available(iOS 15.0, macOS 12.0, *)
public struct WelcomeScreen: View {
    @Binding private var show: Bool

    /// Welcome screen items
    private var items: [WelcomeCell]

    /// Is the continue button available?
    @State private var canContinue: Bool

    /// Action to perform when the welcome screen is closed
    private let closeAction: (() -> Void)?

    /// Helper class to get the App icon, name, version and build number.
    private let helper = OnboardingKitHelper()

    /// WelcomeScreen
    ///
    /// Create a new WelcomeScreen
    ///
    /// - Parameters:
    ///   - show: Binding to show the welcome screen
    ///   - items: Items to show
    ///   - isDismissable: Is the welcome screen dismissable (default: false)
    ///   - closeAction: Action to perform when the welcome screen is closed
    public init(
        show: Binding<Bool>,
        items: [WelcomeCell],
        isDismissable: Bool = false,
        closeAction: ( () -> Void)? = nil
    ) {
        self._show = show
        self.items = items
        self.closeAction = closeAction
        self._canContinue = State(initialValue: isDismissable)

        if items.isEmpty {
            self.items = [
                WelcomeCell(
                    image: "star",
                    title: "Welcome",
                    subtitle: "To %APP_NAME%",
                    color: .blue
                ),
                WelcomeCell(
                    image: "star",
                    title: "To change this",
                    subtitle: "Pass some items to `WelcomeScreen(items: [...])`.",
                    color: .blue
                )
            ]
        }
    }

    /// The view body
    public var body: some View {
        VStack {
            Spacer()

            helper.appIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 8))
                .frame(width: 82, height: 82)
                .padding(.top, 24)
                .accessibilityHidden(true)

            Text("Welcome to \(helper.appName)", bundle: .module)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
                .padding(.horizontal, 48)
                .padding(.bottom, 24)

            ScrollView {
                // Lazy scrollview lets us use .onAppear
                // to look if we are at the last item to continue.
                LazyVStack(spacing: 24) {
                    ForEach(items) { item in
                        item
                            .onAppear {
                                if item.id == items.last?.id {
                                    canContinue = true
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
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
    WelcomeScreen(
        show: .constant(true),
        items: [
            .init(
                image: "star",
                title: "Shine",
                subtitle: "Bright",
                color: .accentColor
            )
        ]
    )
}
