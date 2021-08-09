//
//  FadeTransition.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit
import AutomaticCoordinator

final class FadeTransition: NSObject, Transition {
	var transitioning: UIViewControllerAnimatedTransitioning { return self }
	private let animationDuration: Double = 0.25
}

extension FadeTransition: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let incomingView = transitionContext.view(forKey: .to) else {
			return
		}

		let containerView = transitionContext.containerView
		incomingView.alpha = 0
		containerView.addSubview(incomingView)

		UIView.animate(withDuration: animationDuration, animations: {
			incomingView.alpha = 1.0
		}, completion: { success in
			transitionContext.completeTransition(success)
		})
	}
}
