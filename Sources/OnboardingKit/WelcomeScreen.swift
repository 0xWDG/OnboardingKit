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
    
    /// Welcome screen title
    var title = "Welcome to %APP_NAME%"
    
    /// Welcome screen items
    var items: [WelcomeCell]
    
    /// Is the welcome screen dismissable
    var isDismissable: Bool = true
    
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
    ///   - title: Custom title (default: "Welcome to %APP_NAME%")
    ///   - isDismissable: Is the welcome screen dismissable (default: true)
    ///   - closeAction: Action to perform when the welcome screen is closed
    public init(
        show: Binding<Bool>,
        items: [WelcomeCell],
        title: String = "Welcome to %APP_NAME%",
        isDismissable: Bool = true,
        closeAction: ( () -> Void)? = nil
    ) {
        self._show = show
        self.title = title
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
            if let appicon = helper.getAppIcon() {
                appicon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 82, height: 82)
            }
            Text(.init(helper.replaceVariables(in: title)))
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Spacer()
            
            VStack(spacing: 24) {
                ForEach(items, id: \.title) { item in
                    item
                }
            }
            .padding(.leading)
            
            Spacer()
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
#if os(iOS) || os(macOS)
            .keyboardShortcut(isDismissable ? .defaultAction : .cancelAction)
#endif
        }
        .padding()
        .interactiveDismissDisabled(!isDismissable)
        .background {
            Color.clear
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
