
import UIKit

/// Сущность реализующая маршрутизацию
open class ApplicationRouter: NSObject {

	/// Тип эвента передаваемого в слушателя
	public enum RouterEvent {
		case uikit
		case userInitiative
	}

	private weak var rootController: SystemNavigation?
	private weak var popTransition: Transition?
	private weak var pushTransition: Transition?
	private var listeners: [WeakLifeCycleListener] = []
	private var alreadyHaveRootModule: Bool = false

	public init(rootController: SystemNavigation?) {
		self.rootController = rootController
		super.init()
		self.rootController?.delegate = self
		self.rootController?.presentationController?.delegate = self
		weak var wSelf = self
		self.rootController?.popToRootHandler = {
			guard let self = wSelf else { return }
			self.lastListener?.toRootNofity(in: self)
		}
		self.rootController?.popHandler = {
			guard let self = wSelf else { return }
			self.lastListener?.decrement()
		}
	}
}

// MARK: - Routable

extension ApplicationRouter: Routable {
	public func closeModule(animated: Bool, transition transitionIfCan: Transition?, completion: (() -> Void)?) {
		if rootController?.presentingViewController != nil || lastPresented?.presentingViewController != nil {
			dismissModule(animated: animated, completion: completion)
		} else if let controllersCount = rootController?.viewControllers.count, controllersCount > 1 {
			popModule(transition: transitionIfCan, animated: animated, completion: completion)
		}
	}

	public func pushModule(
		_ module: Presentable,
		transition: Transition?,
		hideBottomBar: Bool,
		animated: Bool,
		completion: (() -> Void)?
	) {
		guard !(module.toPresent is UINavigationController) else {
			return assertionFailure("Нельзя пушить UINavigationController")
		}

		pushTransition = transition
		module.toPresent.hidesBottomBarWhenPushed = hideBottomBar
		rootController?.pushViewController(module.toPresent, animated: animated, completion: completion)
		lastListener?.increment()
	}

	public func popModule(transition: Transition?, animated: Bool, completion: (() -> Void)?) {
		popTransition = transition

		assert(rootController?.presentedViewController == nil, "Нельзя использовать пока имеется модальное представление")

		rootController?.popViewController(animated: animated, completion: completion)
		lastListener?.decrement()
	}

	public func presentModule(
		_ module: Presentable,
		animated: Bool,
		presentationStyle: ModalPresentationStyle,
		transitionStyle: ModalTransitionStyle,
		completion: (() -> Void)?
	) {
		module.toPresent.modalPresentationStyle = presentationStyle.uiModalPresentationStyle
		module.toPresent.modalTransitionStyle = transitionStyle.uiModalTransitionStyle
		UIApplication.shared.topViewController?.present(module.toPresent, animated: animated, completion: completion)
		module.toPresent.presentationController?.delegate = self

		/*
		Важно!
		Если модуль который презентуется - UINavigationController, то счетчик не поднимается, посколько он поднимется в pushModule
		Если модуль который презентуется - UIViewController, то счетчик поднимается
		*/
		if !(module.toPresent is UINavigationController) {
			lastListener?.increment()
		}
	}

	public func dismissModule(animated: Bool, completion: (() -> Void)?) {
		/*
		Важно!
		Если модуль который дисмиссится - UINavigationController, то необходимо вызвать dismissNotify
		Если модуль который дисмиссится - UIViewController, то необходимо вызвать decrement
		Почему? см. presentModule
		*/
		if lastPresented is UINavigationController {
			lastListener?.dismissNotify(event: .userInitiative)
		} else {
			lastListener?.decrement()
		}
		UIApplication.shared.topViewController?.dismiss(animated: animated, completion: completion)
	}

	public func setRootModule(_ module: Presentable, transition: Transition?, hideNavigationBar: Bool, animated: Bool) {
		pushTransition = transition

		if alreadyHaveRootModule {
			lastListener?.startNotify()
		}

		rootController?.setViewControllers([module.toPresent], animated: animated)
		rootController?.setNavigationBarHidden(!hideNavigationBar, animated: animated)

		lastListener?.increment()
		alreadyHaveRootModule = true
	}

	public func popToRootModule(animated: Bool, completion: (() -> Void)?) {
		rootController?.popToRootViewController(animated: animated, completion: completion)
	}

	public func subscribe(_ listener: LifeCycleListener) {
		listeners.append(WeakLifeCycleListener(listener))
	}
}

// MARK: - UINavigationControllerDelegate

extension ApplicationRouter: UINavigationControllerDelegate {
	public func navigationController(
		_: UINavigationController,
		animationControllerFor operation: UINavigationController.Operation,
		from _: UIViewController,
		to _: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		switch operation {
		case .push: return pushTransition?.transitioning
		case .pop: return popTransition?.transitioning
		case .none: return nil
		@unknown default: return nil
		}
	}

	public func navigationController(
		_ navigationController: UINavigationController,
		willShow _: UIViewController,
		animated _: Bool
	) {
		navigationController.topViewController?.transitionCoordinator?.notifyWhenInteractionChanges {
			if !$0.isCancelled { self.lastListener?.decrement() }
		}
	}
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension ApplicationRouter: UIAdaptivePresentationControllerDelegate {
	public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		/*
		Важно!
		Если модуль который дисмиссится - UINavigationController, то необходимо вызвать dismissNotify
		Если модуль который дисмиссится - UIViewController, то необходимо вызвать decrement
		Почему? см. presentModule
		*/
		if presentationController.presentedViewController is UINavigationController {
			lastListener?.dismissNotify(event: .uikit)
		} else {
			lastListener?.decrement()
		}
	}

	public func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
		return UIApplication.shared.topViewController?.modalPresentationStyle ?? .overFullScreen
	}
}

// MARK: - Private

private extension ApplicationRouter {
	var lastPresented: UIViewController? {
		return lastPresented(viewController: rootController)
	}

	func lastPresented(viewController: UIViewController?) -> UIViewController? {
		if viewController?.isBeingDismissed == true {
			return nil
		}
		if viewController?.presentedViewController == nil {
			return viewController
		}
		return lastPresented(viewController: viewController?.presentedViewController) ?? viewController
	}

	var lastListener: LifeCycleListener? {
		listeners = listeners.filter { $0.value != nil }
		return listeners.last { $0.value != nil }?.value
	}
}

private extension UIApplication {
	/// Recursive search presented UIViewController
	func topVC(in viewController: UIViewController?) -> UIViewController? {
		func searchIntoNavigation(_ navVC: UINavigationController) -> UIViewController? {
			return topVC(in: navVC.topViewController)
		}
		func searchIntoTab(_ tabVC: UITabBarController) -> UIViewController? {
			guard let selectedViewController = tabVC.selectedViewController else {
				return nil
			}
			if let selectedNav = selectedViewController as? UINavigationController {
				return searchIntoNavigation(selectedNav)
			}
			return selectedViewController
		}
		if var topController = viewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			if let navController = topController as? UINavigationController {
				return searchIntoNavigation(navController)
			}
			if let tabController = topController as? UITabBarController {
				return searchIntoTab(tabController)
			}
			return topController
		}
		return viewController
	}

	var topViewController: UIViewController? {
		let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
		return topVC(in: keyWindow?.rootViewController)
	}
}

// MARK: - Weak коробка для слушателей

private struct WeakLifeCycleListener {
	weak var value: LifeCycleListener?

	init(_ value: LifeCycleListener?) {
		self.value = value
	}
}
