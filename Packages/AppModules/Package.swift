// swift-tools-version: 6.0
// All feature code lives in this local package; the App target is a shell.
import PackageDescription

let package = Package(
    name: "AppModules",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "Onboarding", targets: ["Onboarding"]),
        .library(name: "Paywall", targets: ["Paywall"]),
        .library(name: "Persistence", targets: ["Persistence"]),
        .library(name: "Support", targets: ["Support"]),
    ],
    targets: [
        .target(name: "Support"),
        .target(name: "DesignSystem"),
        .target(name: "Onboarding", dependencies: ["DesignSystem"]),
        .target(name: "Paywall", dependencies: ["DesignSystem", "Support"]),
        .target(name: "Persistence", dependencies: ["Support"]),
        .target(
            name: "AppFeature",
            dependencies: ["DesignSystem", "Onboarding", "Paywall", "Persistence", "Support"]
        ),
    ]
)
