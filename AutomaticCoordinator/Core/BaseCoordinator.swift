
/// Базовый класс для координатора
open class BaseCoordinator {
	/// Роутер координатора
	public let router: Routable

	/// Родительский координатор
	private weak var parentCoordinator: BaseCoordinator?

	/// Слушатель жизненного цикла флоу
	private let listener = DefaultLifeCycleListener()

	/// Дочерние координаторы
	private var childCoordinators: [BaseCoordinator] = []

	/// Свойство позволяет считать кол-во юнитов в координаторе
	/// Если счетчик >= 0 удаляем себя из родительского координатора
	/// Если счетчик < 0 вызывается assert
	public private(set) var countUnits: Int = 0 {
		didSet {
			assert(countUnits >= 0, "countUnits: \(countUnits) что то пошло не так, исправь!")
			if countUnits == 0 {
				Logger.log("Удалил зависимость \(currentName) из \(parentName)")
				parentCoordinator?.removeChild(self)
			}
		}
	}

	public init(router: Routable, parent: BaseCoordinator? = nil) {
		parentCoordinator = parent
		self.router = router
		self.router.subscribe(listener)

		listener.recieveEvent = { [weak self] event in
			switch event {
			case .decrement: self?.decrement()
			case .increment: self?.increment()
			case .startNotify: self?.startNotify()
			case let .dismissNotify(event): self?.dismissNotify(event: event)
			case let .toRootNofity(router): self?.toRootNofity(in: router)
			}
		}
	}

	deinit {
		Logger.log("\(currentName) dealloc")
	}
}

// MARK: - Private life cycle

private extension BaseCoordinator {
	func addChild(_ coordinator: BaseCoordinator) {
		guard !childCoordinators.contains(where: { $0 === coordinator }) else {
			return
		}

		childCoordinators.append(coordinator)
	}

	func removeChild(_ coordinator: BaseCoordinator) {
		childCoordinators.removeAll { $0 === coordinator }
	}

	func removeAll() {
		Logger.log("Удалил все зависимости из \(currentName)")
		childCoordinators.removeAll()
	}

	func increment() {
		if countUnits == 0 {
			Logger.log("Добавил зависимость \(currentName) в \(parentName)")
			parentCoordinator?.addChild(self)
		}
		countUnits += 1
	}

	func decrement() {
		countUnits -= 1
	}

	func startNotify() {
		Logger.log("Ищу корневой координатор по причине старта нового флоу")
		routerAsTheRoot(router)?.removeAll()
	}

	func toRootNofity(in router: Routable) {
		Logger.log("Ищу координатор в котором этот роутер рутовый")
		routerAsTheRoot(router)?.removeAll()
		routerAsTheRoot(router)?.countUnits = 1
	}

	func dismissNotify(event: ApplicationRouter.RouterEvent) {
		Logger.log("Дисмисс \(event)")
		switch event {
		case .uikit: removeAll()
		case .userInitiative: routerAsTheRoot(router)?.parentCoordinator?.removeChild(self)
		}
	}
}

private extension BaseCoordinator {
	func routerAsTheRoot(_ router: Routable) -> BaseCoordinator? {
		if parentCoordinator?.router !== router {
			return self
		}
		return parentCoordinator?.routerAsTheRoot(router)
	}

	var parentName: String {
		if let parent = parentCoordinator {
			return String(describing: parent.currentName)
		}
		return "Что то рутовое"
	}

	var currentName: String {
		return String(describing: Self.self)
	}
}

