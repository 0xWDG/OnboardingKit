# OnboardingKit

OnboardingKit is a SwiftUI package that helps you create onboarding experiences for your app. It provides a set of views that you can use to create a welcome screen, a what's new screen, and a set of onboarding screens. You can customize the views by providing your own content and colors. OnboardingKit also provides a helper class that you can use to get information about your app, such as the app name, version number, and build number.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FOnboardingKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/OnboardingKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FOnboardingKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/OnboardingKit)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/OnboardingKit)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+

## Installation

Install using Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/OnboardingKit.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "OnboardingKit", package: "OnboardingKit"),
    ]),
]
```

And import it:

```swift
import OnboardingKit
```

## Welcome View Usage

```swift
import OnboardingKit

struct TabbarView: View {
    @State
    private var showWelcomeScreen = {
        if UserDefaults.standard.bool(forKey: "hasSeenIntroduction") {
            return false
        }

        return true
    }()

    private var features: [WelcomeCell] = [
        WelcomeCell(
            image: "star",
            title: "Welcome",
            subtitle: "To %APP_NAME%"
        )
    ]

    var body: some View {
        TabView {
          // Your tabview Code.
        }
        .sheet(isPresented: $showWelcomeScreen) {
            WelcomeScreen(show: $showWelcomeScreen, items: features) {
                UserDefaults.standard.setValue(true, forKey: "hasSeenIntroduction")
            }
        }
    }
}
```

## What's New View Usage

```swift
import OnboardingKit

struct TabbarView: View {
    @State
    private var showWhatsNew = { // This is to show it only on a different version
        if let dictionary = Bundle.main.infoDictionary,
           let dVersion = dictionary["CFBundleShortVersionString"] as? String,
           let whatsNew = UserDefaults.standard.value(forKey: "whatsNew") as? String,
           whatsNew == dVersion {
            return false
        }

        return true
    }()

    var body: some View {
        TabView {
            // Your tabview Code.
        }
        .sheet(isPresented: $showWhatsNew) {
            WhatsNew(
                show: $showWhatsNew,
                text: "This is new!"
            ) {
                if let dictionary = Bundle.main.infoDictionary,
                   let dVersion = dictionary["CFBundleShortVersionString"] as? String {
                    UserDefaults.standard.setValue(dVersion, forKey: "whatsNew")
                }
            }
        }
    }
}
```

### Dynamic replacements in text

| Key             | Replacement                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| `%DEVICE_APPS%` | SF Device icon with apps name (if supported, only iPad and iPhone are supported at this moment) |
| `%DEVICE_TYPE%` | SF Device icon name                                                                             |
| `%APP_NAME%`    | The app's name                                                                                  |
| `%APP_VERSION%` | The App's version number                                                                        |
| `%APP_BUILD%"`  | The App's build number                                                                          |

## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).

