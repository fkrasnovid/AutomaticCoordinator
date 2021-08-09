//
//  CoordinatorFactory.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

protocol CoordinatorFactoryProtocol: AnyObject {
	func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void>
	func makePrototypeStartupCoordinator(
		output: PrototypeStartupCoordinatorOutput & BaseCoordinator,
		router: Routable
	) -> AnyCoordinator<PrototypeStartupCoordinator.Deeplink>

	func makeTabBarCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<TabBarCoordinator.Deeplink>

	func makePrototypeTabCoordinator(parent: BaseCoordinator, tab: Tab)
	-> (view: Presentable, coordinator: AnyCoordinator<PrototypeTabCoordinator.Deeplink>)

	func makePrototypeCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<Void>
	func makeModalPrototypeCoordinator(parent: BaseCoordinator) -> (view: Presentable, coordinator: AnyCoordinator<Void>)
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
	static let shared = CoordinatorFactory()
	let tabFactory = TabFactory()
	private init() {}

	func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void> {
		return AnyCoordinator(ApplicationCoordinator(router: router, coordinatorFactory: self))
	}

	func makePrototypeStartupCoordinator(
		output: PrototypeStartupCoordinatorOutput & BaseCoordinator,
		router: Routable
	) -> AnyCoordinator<PrototypeStartupCoordinator.Deeplink> {
		return AnyCoordinator(
			PrototypeStartupCoordinator(
				output: output,
				router: router,
				parent: output,
				moduleFactory: ModuleFactory.shared,
				transitionFactory: TransitionFactory.shared
			)
		)
	}

	func makeTabBarCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<TabBarCoordinator.Deeplink> {
		let tabbarController = SystemTabBarController()
		let tabbarManager = TabBarManager(tabBar: tabbarController)
		return AnyCoordinator(
			TabBarCoordinator(
				router: router,
				parent: parent,
				coordinatorFactory: self,
				transitionFactory: TransitionFactory.shared,
				tabBarManager: tabbarManager
			)
		)
	}

	func makePrototypeTabCoordinator(parent: BaseCoordinator, tab: Tab)
	-> (view: Presentable, coordinator: AnyCoordinator<PrototypeTabCoordinator.Deeplink>) {
		let navigation = SystemNavigationController(hideNavigationBar: false)
		navigation.tabBarItem = tabFactory.makeBarItem(for: tab)
		let router = ApplicationRouter(rootController: navigation)
		let coordinator = AnyCoordinator(
			PrototypeTabCoordinator(
				router: router,
				parent: parent,
				coordinatorFactory: self,
				moduleFactory: ModuleFactory.shared
			)
		)
		return (navigation, coordinator)
	}

	func makePrototypeCoordinator(router: Routable, parent: BaseCoordinator) -> AnyCoordinator<Void> {
		return AnyCoordinator(
			PrototypeCoordinator(
				router: router,
				parent: parent,
				coordinatorFactory: self,
				moduleFactory: ModuleFactory.shared
			)
		)
	}

	func makeModalPrototypeCoordinator(parent: BaseCoordinator) -> (view: Presentable, coordinator: AnyCoordinator<Void>) {
		let navigation = SystemNavigationController(hideNavigationBar: false)
		let router = ApplicationRouter(rootController: navigation)
		let coordinator = AnyCoordinator(
			PrototypeCoordinator(
				router: router,
				parent: parent,
				coordinatorFactory: self,
				moduleFactory: ModuleFactory.shared
			)
		)
		return (navigation, coordinator)
	}
}
