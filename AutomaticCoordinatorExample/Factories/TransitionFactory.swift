//
//  TransitionFactory.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import AutomaticCoordinator

protocol TransitionFactoryProtocol: AnyObject {
	var fade: Transition { get }
	var dismiss: Transition { get }
	var crossDissolve: Transition { get }
	var custom: Transition { get }
}

final class TransitionFactory: TransitionFactoryProtocol {
	let fade: Transition = FadeTransition()
	let dismiss: Transition = DismissTransition()
	let crossDissolve: Transition = CrossDissolveTransition()
	let custom: Transition = StraightLineTransition()

	static let shared = TransitionFactory()
	private init() {}
}
