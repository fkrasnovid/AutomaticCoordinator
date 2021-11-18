//
//  Tab.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit

enum Tab: Int, CaseIterable {
	case one = 0
	case two
	case three
	case four
	case five

	var info: TabItemInfo {
		switch self {
		case .one: return .init(selectedImage: imageTab)
		case .two: return .init(selectedImage: imageTab)
		case .three: return .init(selectedImage: imageTab)
		case .four: return .init(selectedImage: imageTab)
		case .five: return .init(selectedImage: imageTab)
		}
	}

	struct TabItemInfo {
		let normalImage: UIImage = UIImage(named: "normalTab")!
		let selectedImage: UIImage
	}

	private var imageTab: UIImage {
		UIImage(named: String(self.rawValue))!
	}
}
