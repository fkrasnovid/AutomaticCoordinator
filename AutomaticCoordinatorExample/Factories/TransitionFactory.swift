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
	var fade: Transition { FadeTransition() }
	var dismiss: Transition { DismissTransition() }
	var crossDissolve: Transition { CrossDissolveTransition() }
	var custom: Transition { StraightLineTransition() }

	static let shared = TransitionFactory()
	private init() {}
}
