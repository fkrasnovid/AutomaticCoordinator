//
//  DismissTransition.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit
import AutomaticCoordinator

final class DismissTransition: NSObject, Transition {
	var transitioning: UIViewControllerAnimatedTransitioning { return self }
	private let animationDuration: Double = 0.25
}

extension DismissTransition: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to),
			let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
		else {
			return
		}

		let containerView = transitionContext.containerView
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)

		UIView.transition(with: containerView, duration: animationDuration, options: [.curveEaseInOut]) {
			snapshot.frame = CGRect(
				x: snapshot.bounds.origin.x,
				y: snapshot.bounds.size.height,
				width: snapshot.bounds.size.width,
				height: snapshot.bounds.size.height
			)
		} completion: {
			snapshot.removeFromSuperview()
			transitionContext.completeTransition($0)
		}
	}
}
