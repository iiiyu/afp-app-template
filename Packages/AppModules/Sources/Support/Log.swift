import OSLog

/// Central loggers. Add one static logger per subsystem area; never print().
public enum Log {
    public static let app = Logger(subsystem: AppInfo.bundleID, category: "app")
    public static let store = Logger(subsystem: AppInfo.bundleID, category: "store")
    public static let data = Logger(subsystem: AppInfo.bundleID, category: "data")
}
