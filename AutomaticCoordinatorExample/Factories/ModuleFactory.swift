//
//  ModuleFactory.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

final class ModuleFactory: ModuleFactoryProtocol {
	static let shared = ModuleFactory()
	private init() {}

	func makePrototypeStartupModule(output: PrototypeStartupModuleOutput, deeplink: PrototypeStartupCoordinator.Deeplink) -> Presentable {
		return PrototypeStartupViewController(output: output, deeplink: deeplink)
	}

	func makeTabModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void
	) -> Presentable {
		return PrototypeModuleViewController(
			model: .init(
				pushUnitHandler: pushUnitHandler,
				pushModuleHandler: pushModuleHandler,
				closeUnitOrModuleHandler: nil,
				popToRootHandler: nil,
				modalModuleHandler: modalModuleHandler,
				modalUnitHandler: modalUnitHandler,
				closeModalHandler: nil
			)
		)
	}

	func makePushModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		closeUnitOrModuleHandler: @escaping () -> Void,
		popToRootHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void
	) -> Presentable {
		return PrototypeModuleViewController(
			model: .init(
				pushUnitHandler: pushUnitHandler,
				pushModuleHandler: pushModuleHandler,
				closeUnitOrModuleHandler: closeUnitOrModuleHandler,
				popToRootHandler: popToRootHandler,
				modalModuleHandler: modalModuleHandler,
				modalUnitHandler: modalUnitHandler,
				closeModalHandler: nil
			)
		)
	}

	func makePrototypeModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		closeUnitOrModuleHandler: @escaping () -> Void,
		popToRootHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void,
		closeModalHandler: @escaping () -> Void
	) -> Presentable {
		return PrototypeModuleViewController(
			model: .init(
				pushUnitHandler: pushUnitHandler,
				pushModuleHandler: pushModuleHandler,
				closeUnitOrModuleHandler: closeUnitOrModuleHandler,
				popToRootHandler: popToRootHandler,
				modalModuleHandler: modalModuleHandler,
				modalUnitHandler: modalUnitHandler,
				closeModalHandler: closeModalHandler
			)
		)
	}

	func makeSingleModalModule(
		modalModuleHandler: @escaping () -> Void,
		closeModalHandler: @escaping () -> Void
	) -> Presentable {
		return PrototypeModuleViewController(
			model: .init(
				pushUnitHandler: nil,
				pushModuleHandler: nil,
				closeUnitOrModuleHandler: nil,
				popToRootHandler: nil,
				modalModuleHandler: modalModuleHandler,
				modalUnitHandler: nil,
				closeModalHandler: closeModalHandler
			)
		)
	}
}

protocol ModuleFactoryProtocol: AnyObject {
	func makePrototypeStartupModule(output: PrototypeStartupModuleOutput, deeplink: PrototypeStartupCoordinator.Deeplink) -> Presentable
	func makeTabModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void
	) -> Presentable

	func makePushModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		closeUnitOrModuleHandler: @escaping () -> Void,
		popToRootHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void
	) -> Presentable

	func makePrototypeModule(
		pushUnitHandler: @escaping () -> Void,
		pushModuleHandler: @escaping () -> Void,
		closeUnitOrModuleHandler: @escaping () -> Void,
		popToRootHandler: @escaping () -> Void,
		modalModuleHandler: @escaping () -> Void,
		modalUnitHandler: @escaping () -> Void,
		closeModalHandler: @escaping () -> Void
	) -> Presentable

	func makeSingleModalModule(
		modalModuleHandler: @escaping () -> Void,
		closeModalHandler: @escaping () -> Void
	) -> Presentable
}
