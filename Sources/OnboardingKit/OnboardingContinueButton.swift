//
//  OnboardingContinueButton.swift
//  OnboardingKit
//
//  Created by Wesley de Groot on 14/06/2026.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/OnboardingKit
//  MIT LICENCE

import SwiftUI

/// The shared continue action used by onboarding screens.
struct OnboardingContinueButton: View {
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Continue", bundle: .module)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!isEnabled)
#if os(iOS) || os(macOS)
        .keyboardShortcut(.defaultAction)
#endif
    }
}
