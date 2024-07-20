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
    @Binding
    var show: Bool

    /// What's new text
    var text: String

    /// Is the view dismissable
    var isDismissable: Bool = true

    /// Action to perform when the view is closed
    var closeAction: (() -> Void)?

    /// Can we continue?
    @State
    var canContinue: Bool = false

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
        self.isDismissable = isDismissable
        self.closeAction = closeAction
    }
    /// The view body
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                helper.getAppIcon()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 82, height: 82)

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
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text(.init(text))
                    Text("").onAppear {
                        self.canContinue = true
                    }
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
        .onAppear {
            if isDismissable {
                // View is dismissable so we can continue
                canContinue = true
            }
        }
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
