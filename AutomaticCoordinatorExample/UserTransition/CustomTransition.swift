//
//  CustomTransition.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit
import AutomaticCoordinator

final class StraightLineTransition: NSObject, Transition {
	var transitioning: UIViewControllerAnimatedTransitioning { return self }

	private let cornerToSlideFrom: UIRectCorner = {
		let topOrBottom: Bool = .random()
		let leftOrRight: Bool = .random()
		return topOrBottom ? leftOrRight ? .topLeft : .topRight : leftOrRight ? .bottomLeft : .bottomRight
	}()
	private let animationDuration: Double = 0.33
}

extension StraightLineTransition: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to)
		else { return }

		let containerView = transitionContext.containerView
		containerView.addSubview(toVC.view)
		containerView.addSubview(fromVC.view)

		let size: CGSize = fromVC.view.frame.size

		let toPath = UIBezierPath()
		let fromPath = UIBezierPath()

		if (cornerToSlideFrom == .topRight) {
			toPath.move(to: CGPoint(x: -size.width, y: 0))
			toPath.addLine(to: CGPoint(x: size.width, y: size.height * 2))
			toPath.addLine(to: CGPoint(x: -size.width, y: size.height * 2))
			toPath.close()

			fromPath.move(to: CGPoint(x: 0, y: -size.height))
			fromPath.addLine(to: CGPoint(x: size.width * 2, y: size.height))
			fromPath.addLine(to: CGPoint(x: 0, y: size.height))
			fromPath.close()
		} else if (cornerToSlideFrom == .bottomLeft) {
			toPath.move(to: CGPoint(x: size.width * 2, y: size.height))
			toPath.addLine(to: CGPoint(x: 0, y: -size.height))
			toPath.addLine(to: CGPoint(x: size.width * 2, y: -size.height))
			toPath.close()

			fromPath.move(to: CGPoint(x: size.width, y: size.height * 2))
			fromPath.addLine(to: CGPoint(x: -size.width, y: 0))
			fromPath.addLine(to: CGPoint(x: size.width, y: 0))
			fromPath.close()
		} else if (cornerToSlideFrom == .bottomRight) {
			toPath.move(to: CGPoint(x: -size.width, y: size.height))
			toPath.addLine(to: CGPoint(x: size.width, y: -size.height))
			toPath.addLine(to: CGPoint(x: -size.width, y: -size.height))
			toPath.close()

			fromPath.move(to: CGPoint(x: 0, y: size.height * 2))
			fromPath.addLine(to: CGPoint(x: size.width * 2, y: 0))
			fromPath.addLine(to: CGPoint.zero)
			fromPath.close()
		} else if (cornerToSlideFrom == .topLeft) {
			toPath.move(to: CGPoint(x: size.width * 2, y: size.height))
			toPath.addLine(to: CGPoint(x: 0, y: size.height * 2))
			toPath.addLine(to: CGPoint(x: size.width * 2, y: size.height * 2))
			toPath.close()

			fromPath.move(to: CGPoint(x: size.width, y: size.height * -2))
			fromPath.addLine(to: CGPoint(x: -size.width, y: size.height))
			fromPath.addLine(to: CGPoint(x: size.width, y: size.height))
			fromPath.close()
		}

		let shapeLayer = CAShapeLayer()
		shapeLayer.path = fromPath.cgPath
		shapeLayer.bounds = CGRect(x: 0, y: 0, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
		shapeLayer.position = CGPoint(x: fromVC.view.bounds.size.width / 2, y: fromVC.view.bounds.size.height / 2)

		fromVC.view.layer.mask = shapeLayer

		let animation = BasicAnimation()
		animation.keyPath = "path"
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		animation.duration = self.animationDuration
		animation.fromValue = fromPath.cgPath
		animation.toValue = toPath.cgPath
		animation.autoreverses = false
		animation.onFinish = { [weak transitionContext, weak fromVC, weak animation] in
			transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled)
			fromVC?.view.layer.mask = nil
			animation?.delegate = nil
		}
		shapeLayer.add(animation, forKey: "path")
	}
}

private class BasicAnimation: CABasicAnimation, CAAnimationDelegate {
	public var onFinish: (() -> (Void))?

	override init() {
		super.init()
		self.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		onFinish?()
	}
}
