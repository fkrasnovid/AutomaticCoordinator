
/// Реализация стирания типа для Coordinator
public final class AnyCoordinator<StartOption>: Coordinator {
	private let startWithOptionClosure: (StartOption) -> Void

	public init<T: Coordinator>(_ coordinator: T) where T.StartOption == StartOption {
		startWithOptionClosure = coordinator.start(with:)
	}

	public func start(with option: StartOption) {
		startWithOptionClosure(option)
	}
}

// MARK: - Default

public extension AnyCoordinator where StartOption == Void {
	func start() {
		start(with: ())
	}
}
