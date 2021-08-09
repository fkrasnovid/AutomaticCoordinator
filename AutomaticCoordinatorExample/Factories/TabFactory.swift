//
//  TabFactory.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit

protocol TabFactoryProtocol {
	func makeBarItem(for tab: Tab) -> UITabBarItem
}

final class TabFactory: TabFactoryProtocol {
	func makeBarItem(for tab: Tab) -> UITabBarItem {
		return UITabBarItem(rootTab: tab).decorateBarItem()
	}
}

private extension UITabBarItem {
	convenience init(rootTab: Tab) {
		self.init(
			title: rootTab.info.title,
			image: nil,
			selectedImage: nil
		)
	}

	func decorateBarItem() -> UITabBarItem {
		imageInsets = .init(top: 2, left: 0, bottom: -2, right: 0)
		return self
	}
}
