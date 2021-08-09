//
//  PrototypeStartupCoordinator.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

protocol PrototypeStartupCoordinatorOutput: AnyObject {
	func startupFinish(deeplink: PrototypeStartupCoordinator.Deeplink)
}

final class PrototypeStartupCoordinator: BaseCoordinator {

	enum Deeplink {
		case one
		case two
		case three
	}

	private weak var output: PrototypeStartupCoordinatorOutput?
	private let moduleFactory: ModuleFactoryProtocol
	private let transitionFactory: TransitionFactoryProtocol

	init(
		output: PrototypeStartupCoordinatorOutput,
		router: Routable,
		parent: BaseCoordinator,
		moduleFactory: ModuleFactoryProtocol,
		transitionFactory: TransitionFactoryProtocol
	) {
		self.output = output
		self.moduleFactory = moduleFactory
		self.transitionFactory = transitionFactory
		super.init(router: router, parent: parent)
	}
}

// MARK: - Coordinator

extension PrototypeStartupCoordinator: Coordinator {
	func start(with option: Deeplink) {
		switch option {
		case .one: startModuleOne()
		case .two: startModuleTwo()
		case .three: startModuleThree()
		}
	}
}

extension PrototypeStartupCoordinator: PrototypeStartupModuleOutput {
	func moduleFinish(with deeplink: PrototypeStartupCoordinator.Deeplink) {
		output?.startupFinish(deeplink: deeplink)
	}
}

// MARK: - Navigation

private extension PrototypeStartupCoordinator {
	func startModuleOne() {
		let module = moduleFactory.makePrototypeStartupModule(output: self, deeplink: .one)
		router.setRootModule(module, transition: transitionFactory.fade)
	}

	func startModuleTwo() {
		let module = moduleFactory.makePrototypeStartupModule(output: self, deeplink: .two)
		router.setRootModule(module, transition: transitionFactory.custom)
	}

	func startModuleThree() {
		let module = moduleFactory.makePrototypeStartupModule(output: self, deeplink: .three)
		router.setRootModule(module, transition: transitionFactory.crossDissolve)
	}
}
