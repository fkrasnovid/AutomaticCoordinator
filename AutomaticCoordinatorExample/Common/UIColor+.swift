//
//  UIColor+.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit

extension UIColor {
	static var random: UIColor {
		return UIColor(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			alpha: 1.0
		)
	}

	static var customMint: UIColor {
		return .init(red: 89/255, green: 196/255, blue: 189/255, alpha: 1)
	}
}
