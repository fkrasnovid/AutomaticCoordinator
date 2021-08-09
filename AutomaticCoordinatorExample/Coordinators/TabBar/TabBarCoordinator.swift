//
//  TabBarCoordinator.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

final class TabBarCoordinator: BaseCoordinator {

	enum Deeplink {
		case initial
	}

	private let coordinatorFactory: CoordinatorFactoryProtocol
	private let transitionFactory: TransitionFactory
	private let tabBarManager: TabBarManagerProtocol

	init(
		router: Routable,
		parent: BaseCoordinator,
		coordinatorFactory: CoordinatorFactoryProtocol,
		transitionFactory: TransitionFactory,
		tabBarManager: TabBarManagerProtocol
	) {
		self.coordinatorFactory = coordinatorFactory
		self.transitionFactory = transitionFactory
		self.tabBarManager = tabBarManager
		super.init(router: router, parent: parent)
	}
}

extension TabBarCoordinator: Coordinator {
	func start(with option: Deeplink) {
		tabBarManager.delegate = self
		prepareTabs()
	}
}

extension TabBarCoordinator: TabBarManagerDelegate {
	func repeatedTap(tab: Tab) {
		print(#function)
	}

	func didSelectTab(tab: Tab) {
		print(#function)
	}
}

// MARK: - Navigation

private extension TabBarCoordinator {
	func prepareTabs() {
		tabBarManager.setPresentable([
			makeTabOne(),
			makeTabTwo(),
			makeTabThree(),
			makeTabFour(),
			makeTabFive()
		])
		router.setRootModule(tabBarManager.tabBarPresentable, transition: transitionFactory.custom)
	}

	func makeTabOne() -> Presentable {
		let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .one)
		unit.coordinator.start(with: .initial)
		return unit.view
	}

	func makeTabTwo() -> Presentable {
		let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .two)
		unit.coordinator.start(with: .initial)
		return unit.view
	}

	func makeTabThree() -> Presentable {
		let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .three)
		unit.coordinator.start(with: .initial)
		return unit.view
	}

	func makeTabFour() -> Presentable {
		let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .four)
		unit.coordinator.start(with: .initial)
		return unit.view
	}

	func makeTabFive() -> Presentable {
		let unit = coordinatorFactory.makePrototypeTabCoordinator(parent: self, tab: .five)
		unit.coordinator.start(with: .initial)
		return unit.view
	}
}
