import Foundation

public enum AppInfo {
    public static var bundleID: String {
        Bundle.main.bundleIdentifier ?? "unknown"
    }

    public static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }

    public static var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }
}
