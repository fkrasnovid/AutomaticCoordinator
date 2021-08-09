
public final class AutomaticCoordinatorConfiguration {
	internal static var logEnabled = false

	public static func enabledDebugLog(_ flag: Bool) {
		logEnabled = flag
	}
}

internal final class Logger {
	static func log(_ args: Any) {
		guard AutomaticCoordinatorConfiguration.logEnabled else { return }
		print(args)
	}
}
