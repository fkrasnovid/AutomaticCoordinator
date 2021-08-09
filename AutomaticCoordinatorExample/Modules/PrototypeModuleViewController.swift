//
//  PrototypeModuleViewController.swift
//  AutomaticCoordinatorExample
//
//  Created by Filipp K on 08.08.2021.
//

import UIKit

final class PrototypeModuleViewController: UIViewController {
	struct Model {
		let pushUnitHandler: (() -> Void)?
		let pushModuleHandler: (() -> Void)?
		let popUnitOrModuleHandler: (() -> Void)?
		let popToRootHandler: (() -> Void)?
		let modalModuleHandler: (() -> Void)?
		let modalUnitHandler: (() -> Void)?
		let closeModalHandler: (() -> Void)?
	}

	private let model: Model
	private let stackView: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .center
		stack.spacing = 8
		stack.axis = .vertical
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	init(model: Model) {
		self.model = model
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .random
		title = .randomWord

		view.addSubview(stackView)


		if model.pushUnitHandler != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("PushUnitAction", for: .normal)
			button.addTarget(self, action: #selector(pushUnitAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		if model.pushModuleHandler != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("PushModuleAction", for: .normal)
			button.addTarget(self, action: #selector(pushModuleAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		if model.popUnitOrModuleHandler != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("PopUnitOrModuleAction", for: .normal)
			button.addTarget(self, action: #selector(popUnitOrModuleAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		let viewControllerCount = navigationController?.viewControllers.count ?? 1

		if model.popToRootHandler != nil, navigationController != nil, viewControllerCount > 1 {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("PopToRootAction", for: .normal)
			button.addTarget(self, action: #selector(popToRootAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		if model.modalModuleHandler != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("Open modalModuleAction", for: .normal)
			button.addTarget(self, action: #selector(modalModuleAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		if model.modalUnitHandler != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("Open modalUnitAction", for: .normal)
			button.addTarget(self, action: #selector(modalUnitAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		if model.closeModalHandler != nil, presentingViewController != nil {
			let button = UIButton(type: .custom)
			button.backgroundColor = .black
			button.setTitleColor(.white, for: .normal)
			button.setTitle("CloseModalAction", for: .normal)
			button.addTarget(self, action: #selector(closeModalAction), for: .touchUpInside)
			stackView.addArrangedSubview(button)
		}

		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}

private extension PrototypeModuleViewController {
	@objc func pushUnitAction() {
		model.pushUnitHandler?()
	}

	@objc func pushModuleAction() {
		model.pushModuleHandler?()
	}

	@objc func popUnitOrModuleAction() {
		model.popUnitOrModuleHandler?()
	}

	@objc func popToRootAction() {
		model.popToRootHandler?()
	}

	@objc func modalModuleAction() {
		model.modalModuleHandler?()
	}

	@objc func modalUnitAction() {
		model.modalUnitHandler?()
	}

	@objc func closeModalAction() {
		model.closeModalHandler?()
	}
}
