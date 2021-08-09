//
//  PrototypeTabCoordinator.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

final class PrototypeTabCoordinator: BaseCoordinator {
	enum Deeplink {
		case initial
	}

	private let coordinatorFactory: CoordinatorFactoryProtocol
	private let moduleFactory: ModuleFactoryProtocol

	init(
		router: Routable,
		parent: BaseCoordinator,
		coordinatorFactory: CoordinatorFactoryProtocol,
		moduleFactory: ModuleFactoryProtocol
	) {
		self.coordinatorFactory = coordinatorFactory
		self.moduleFactory = moduleFactory
		super.init(router: router, parent: parent)
	}
}

extension PrototypeTabCoordinator: Coordinator {
	func start(with option: Deeplink) {
		switch option {
		case .initial: showInitial()
		}
	}
}

// MARK: - Navigation

extension PrototypeTabCoordinator {
	func showInitial() {
		weak var wSelf = self
		let module = moduleFactory.makeTabModule(
			pushUnitHandler: {
				wSelf?.showUnit()
			},
			pushModuleHandler: {
				wSelf?.showModule()
			},
			modalModuleHandler: {
				wSelf?.presentModule()
			},
			modalUnitHandler: {
				wSelf?.openUnitModal()
			}
		)
		router.pushModule(module)
	}

	func showModule() {
		weak var wSelf = self
		let module = moduleFactory.makePushModule(
			pushUnitHandler: {
				wSelf?.showUnit()
			},
			pushModuleHandler: {
				wSelf?.showModule()
			},
			popUnitOrModuleHandler: {
				wSelf?.router.closeModule()
			},
			popToRootHandler: {
				wSelf?.router.popToRootModule()
			},
			modalModuleHandler: {
				wSelf?.presentModule()
			},
			modalUnitHandler: {
				wSelf?.openUnitModal()
			}
		)

		router.pushModule(module)
	}

	func presentModule() {
		weak var wSelf = self
		let module = moduleFactory.makeSingleModalModule(
			modalModuleHandler: {
				wSelf?.presentModule()
			},
			closeModalHandler: {
				wSelf?.router.closeModule()
			}
		)

		if #available(iOS 13.0, *) {
			router.presentModule(module, presentationStyle: .automatic)
		} else {
			router.presentModule(module, presentationStyle: .fullScreen)
		}
	}

	func showUnit() {
		let coordinator = coordinatorFactory.makePrototypeCoordinator(router: router, parent: self)
		coordinator.start()
	}

	func openUnitModal() {
		let unit = coordinatorFactory.makeModalPrototypeCoordinator(parent: self)
		unit.coordinator.start()
		if #available(iOS 13.0, *) {
			router.presentModule(unit.view, presentationStyle: .automatic)
		} else {
			router.presentModule(unit.view, presentationStyle: .fullScreen)
		}
	}
}
