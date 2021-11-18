
/// Интерфейс роутера для системы координаторов
public protocol Routable: AnyObject {
	///  Push модуля
	/// - Parameters:
	///   - module: модуль для операции
	///   - transition: анимация перехода
	///   - hideBottomBar: флаг скрыть/показать tabbar
	///   - animated: флаг анимации
	///   - completion: вызываемый блок после выполнения
	func pushModule(
		_ module: Presentable,
		transition: Transition?,
		hideBottomBar: Bool,
		animated: Bool,
		completion: (() -> Void)?
	)

	/// Установить root модуль
	/// - Parameters:
	///   - module: модуль для установки
	///   - transition: анимация перехода
	///   - hideNavigationBar: флаг скрыть/показать navigationBar
	///   - animated: флаг анимации
	func setRootModule(_ module: Presentable, transition: Transition?, hideNavigationBar: Bool, animated: Bool)

	/// Pop модуля
	/// - Parameters:
	///   - transition: анимация перехода
	///   - animated: флаг анимации
	///   - completion: вызываемый блок после выполнения
	func popModule(transition: Transition?, animated: Bool, completion: (() -> Void)?)

	/// PopToRoot модуля, сбрасывает все текущие флоу до начального
	/// - Parameters:
	///   - animated: флаг анимации
	///   - completion: вызываемый блок после выполнения
	func popToRootModule(animated: Bool, completion: (() -> Void)?)

	/// Презентация модуля модально
	/// - Parameters:
	///   - module: модуль для презентации
	///   - animated: флаг анимации
	///   - presentationStyle: стиль презентации
	///   - transitionStyle: стиль перехода
	///   - completion: вызываемый блок после выполнения
	func presentModule(
		_ module: Presentable,
		animated: Bool,
		presentationStyle: ModalPresentationStyle,
		transitionStyle: ModalTransitionStyle,
		completion: (() -> Void)?
	)

	/// Dismiss последнего модального модуля
	/// - Parameters:
	///   - animated: флаг анимации
	///   - completion: вызываемый блок после выполнения
	func dismissModule(animated: Bool, completion: (() -> Void)?)

	/// Pop/Dismiss последнего модуля
	/// - Parameters:
	///   - animated: флаг анимации
	///   - transitionIfCan: анимация перехода, если возможна
	///   - completion: вызываемый блок после выполнения
	func closeModule(animated: Bool, transition transitionIfCan: Transition?, completion: (() -> Void)?)

	/// Подписать на изменения сущность для контроля жизненного цикла
	/// - Parameter listener: слушатель
	func subscribe(_ listener: LifeCycleListener)
}

// MARK: - Default

public extension Routable {
	func presentModule(
		_ module: Presentable,
		animated: Bool = true,
		presentationStyle: ModalPresentationStyle = .pageSheet,
		transitionStyle: ModalTransitionStyle = .coverVertical,
		completion: (() -> Void)? = nil
	) {
		presentModule(
			module, animated: animated, presentationStyle: presentationStyle, transitionStyle: transitionStyle, completion: completion
		)
	}

	func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
		dismissModule(animated: animated, completion: completion)
	}

	func popToRootModule(animated: Bool = true, completion: (() -> Void)? = nil) {
		popToRootModule(animated: animated, completion: completion)
	}

	func pushModule(
		_ module: Presentable,
		transition: Transition? = nil,
		hideBottomBar: Bool = false,
		animated: Bool = true,
		completion: (() -> Void)? = nil
	) {
		pushModule(module, transition: transition, hideBottomBar: hideBottomBar, animated: animated, completion: completion)
	}

	func popModule(
		transition: Transition? = nil,
		animated: Bool = true,
		completion: (() -> Void)? = nil
	) {
		popModule(transition: transition, animated: animated, completion: completion)
	}

	func setRootModule(_ module: Presentable, transition: Transition? = nil, hideNavigationBar: Bool = true, animated: Bool = true) {
		setRootModule(module, transition: transition, hideNavigationBar: hideNavigationBar, animated: animated)
	}

	func closeModule(animated: Bool = true, transition transitionIfCan: Transition? = nil, completion: (() -> Void)? = nil) {
		closeModule(animated: animated, transition: transitionIfCan, completion: completion)
	}
}
