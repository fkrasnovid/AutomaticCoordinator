
/// Интерфейс координатора
public protocol Coordinator: AnyObject {
	associatedtype StartOption

	/// Начинает флоу модуля полагаясь на переданную опцию
	/// - Parameter option: опция запуска модуля
	func start(with option: StartOption)
}

public extension Coordinator where StartOption == Void {
	func start() {
		start(with: ())
	}
}
