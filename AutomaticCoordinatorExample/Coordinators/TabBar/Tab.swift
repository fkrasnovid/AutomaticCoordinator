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
		case .one: return .init(title: "One")
		case .two: return .init(title: "Two")
		case .three: return .init(title: "Three")
		case .four: return .init(title: "Four")
		case .five: return .init(title: "Five")
		}
	}

	struct TabItemInfo {
		let title: String
	}
}
