//
//  ApplicationCoordinator.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

/// Координатор приложения
final class ApplicationCoordinator: BaseCoordinator {
	private let coordinatorFactory: CoordinatorFactoryProtocol

	init(
		router: Routable,
		coordinatorFactory: CoordinatorFactoryProtocol
	) {
		self.coordinatorFactory = coordinatorFactory
		super.init(router: router)
	}
}

// MARK: - Coordinator

extension ApplicationCoordinator: Coordinator {
	func start(with option: Void) {
		startStartupOne()
	}
}

extension ApplicationCoordinator: PrototypeStartupCoordinatorOutput {
	func startupFinish(deeplink: PrototypeStartupCoordinator.Deeplink) {
		switch deeplink {
		case .one: startStartupTwo()
		case .two: startStartupThree()
		case .three: startTabBarCoordinator()
		}
	}
}

// MARK: - Navigation

private extension ApplicationCoordinator {
	func startStartupOne() {
		let coordinator = coordinatorFactory.makePrototypeStartupCoordinator(output: self, router: router)
		coordinator.start(with: .one)
	}

	func startStartupTwo() {
		let coordinator = coordinatorFactory.makePrototypeStartupCoordinator(output: self, router: router)
		coordinator.start(with: .two)
	}

	func startStartupThree() {
		let coordinator = coordinatorFactory.makePrototypeStartupCoordinator(output: self, router: router)
		coordinator.start(with: .three)
	}

	func startTabBarCoordinator() {
		let coordinator = coordinatorFactory.makeTabBarCoordinator(router: router, parent: self)
		coordinator.start(with: .initial)
	}
}
