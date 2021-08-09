//
//  PrototypeStartupViewController.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit

protocol PrototypeStartupModuleOutput: AnyObject {
	func moduleFinish(with deeplink: PrototypeStartupCoordinator.Deeplink)
}

final class PrototypeStartupViewController: UIViewController {
	private weak var output: PrototypeStartupModuleOutput?
	private let deeplink: PrototypeStartupCoordinator.Deeplink

	init(
		output: PrototypeStartupModuleOutput,
		deeplink: PrototypeStartupCoordinator.Deeplink
	) {
		self.output = output
		self.deeplink = deeplink
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		switch deeplink {
		case .one: proceedOne()
		case .two: proceedTwo()
		case .three: proceedThree()
		}
	}
}

private extension PrototypeStartupViewController {
	func proceedOne() {
		view.backgroundColor = .random
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.output?.moduleFinish(with: self.deeplink)
		}
	}

	func proceedTwo() {
		view.backgroundColor = .random
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.output?.moduleFinish(with: self.deeplink)
		}
	}

	func proceedThree() {
		view.backgroundColor = .random
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.output?.moduleFinish(with: self.deeplink)
		}
	}
}
