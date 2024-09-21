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

#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

/// WelcomeScreen
///
/// The welcome screen for your app.
@available(iOS 15.0, macOS 12.0, *)
public struct WelcomeScreen: View {
    @Binding var show: Bool

    /// Welcome screen items
    var items: [WelcomeCell]

    /// Is the welcome screen dismissable
    var isDismissable: Bool = true

    /// Is the continue button available?
    @State
    var canContinue: Bool = false

    /// Action to perform when the welcome screen is closed
    var closeAction: (() -> Void)?

    /// Helper class to get the App icon, name, version and build number.
    let helper = OnboardingKitHelper()

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
        self.isDismissable = isDismissable
        self.closeAction = closeAction

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
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 82, height: 82)
                .padding(.top, 24)

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
                    ForEach(items, id: \.title) { item in
                        item.onAppear {
                            if item.title == items.last?.title {
                                self.canContinue = true
                            }
                        }
                    }

                }
                .padding(.leading)
            }

            Spacer()
            Spacer()

            Button(action: {
                self.closeAction?()
                self.show = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Continue", bundle: .module)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            })
            .disabled(!canContinue)
            .frame(height: 50)
            .background(canContinue ? Color.blue : Color.gray)
            .cornerRadius(15)
#if os(iOS) || os(macOS)
            .keyboardShortcut(canContinue ? .defaultAction : .cancelAction)
#endif
        }
        .padding()
        .interactiveDismissDisabled(!canContinue)
        .background {
            Color.clear
        }
        .onAppear {
            if isDismissable {
                // View is dismissable, so we can always continue
                canContinue = true
            }
        }
    }
}

struct OnboardingKit_Previews: PreviewProvider {
    static var previews: some View {
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
}
