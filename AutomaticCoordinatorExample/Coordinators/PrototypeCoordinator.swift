//
//  PrototypeCoordinator.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

final class PrototypeCoordinator: BaseCoordinator {
	private let moduleFactory: ModuleFactoryProtocol
	private let coordinatorFactory: CoordinatorFactoryProtocol

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

extension PrototypeCoordinator: Coordinator {
	func start(with option: Void) {
		showInital()
	}
}

// MARK: - Navigation

private extension PrototypeCoordinator {
	func showInital() {
		weak var wSelf = self
		let module = moduleFactory.makePrototypeModule(
			pushUnitHandler: {
				wSelf?.showUnit()
			},
			pushModuleHandler: {
				wSelf?.showModule()
			},
			closeUnitOrModuleHandler: {
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
			},
			closeModalHandler: {
				wSelf?.router.dismissModule()
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
			closeUnitOrModuleHandler: {
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
		router.presentModule(unit.view)
	}
}
