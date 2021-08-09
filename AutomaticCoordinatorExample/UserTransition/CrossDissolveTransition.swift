//
//  CrossDissolveTransition.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit
import AutomaticCoordinator

final class CrossDissolveTransition: NSObject, Transition {
	var transitioning: UIViewControllerAnimatedTransitioning { return self }
	private let animationDuration: Double = 0.25
}

extension CrossDissolveTransition: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let incomingView = transitionContext.view(forKey: .to) else {
			return
		}

		let containerView = transitionContext.containerView
		containerView.addSubview(incomingView)

		UIView.transition(from: containerView, to: incomingView, duration: animationDuration, options: [.transitionCrossDissolve]) {
			transitionContext.completeTransition($0)
		}
	}
}
