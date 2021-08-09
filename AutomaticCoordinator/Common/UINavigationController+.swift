import UIKit

/// Расширение UINavigationController для завершающих замыканий
extension UINavigationController {
	func pushViewController(
		_ viewController: UIViewController,
		animated: Bool = true,
		completion: (() -> Void)?
	) {
		pushViewController(viewController, animated: animated)
		runCompletionIfNeeded(animated: animated, completion: completion)
	}

	func popViewController(animated: Bool = true, completion: (() -> Void)?) {
		popViewController(animated: animated)
		runCompletionIfNeeded(animated: animated, completion: completion)
	}

	func popToRootViewController(animated: Bool = true, completion: (() -> Void)?) {
		popToRootViewController(animated: animated)
		runCompletionIfNeeded(animated: animated, completion: completion)
	}

	private func runCompletionIfNeeded(animated: Bool, completion: (() -> Void)?) {
		guard let coordinator = transitionCoordinator, animated else {
			completion?()
			return
		}

		coordinator.animate(alongsideTransition: nil) { _ in
			completion?()
		}
	}
}
