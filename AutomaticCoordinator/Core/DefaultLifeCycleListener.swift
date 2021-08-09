
/// Дефолтная реализация интерфейса слушателя жизненного цикла флоу
public final class DefaultLifeCycleListener: LifeCycleListener {
	public enum Event {
		case increment
		case decrement
		case startNotify
		case dismissNotify(event: ApplicationRouter.RouterEvent)
		case toRootNofity(router: Routable)
	}

	public var recieveEvent: ((Event) -> Void)?

	public func increment() {
		recieveEvent?(.increment)
	}

	public func decrement() {
		recieveEvent?(.decrement)
	}

	public func startNotify() {
		recieveEvent?(.startNotify)
	}

	public func dismissNotify(event: ApplicationRouter.RouterEvent) {
		recieveEvent?(.dismissNotify(event: event))
	}

	public func toRootNofity(in router: Routable) {
		recieveEvent?(.toRootNofity(router: router))
	}

	public init() {}
}
