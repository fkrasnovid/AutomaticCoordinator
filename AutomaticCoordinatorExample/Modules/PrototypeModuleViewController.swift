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
		let closeUnitOrModuleHandler: (() -> Void)?
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

	deinit {
		print("\(title ?? "")ViewController dealloc")
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .random
		title = .randomWord

		view.addSubview(stackView)

		weak var wSelf = self

		if model.pushUnitHandler != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Push координатора с модулем") {
					wSelf?.model.pushUnitHandler?()
				}
			)
		}

		if model.pushModuleHandler != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Push модуля") {
					wSelf?.model.pushModuleHandler?()
				}
			)
		}

		if model.closeUnitOrModuleHandler != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Закрыть координатор или модуль") {
					wSelf?.model.closeUnitOrModuleHandler?()
				}
			)
		}

		let viewControllerCount = navigationController?.viewControllers.count ?? 1

		if model.popToRootHandler != nil, navigationController != nil, viewControllerCount > 1 {
			stackView.addArrangedSubview(
				HandlerButton(text: "Pop to root") {
					wSelf?.model.popToRootHandler?()
				}
			)
		}

		if model.modalModuleHandler != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Открыть модуль модально") {
					wSelf?.model.modalModuleHandler?()
				}
			)
		}

		if model.modalUnitHandler != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Открыть координатор с модулем модально") {
					wSelf?.model.modalUnitHandler?()
				}
			)
		}

		if model.closeModalHandler != nil, presentingViewController != nil {
			stackView.addArrangedSubview(
				HandlerButton(text: "Закрыть модальное представление") {
					wSelf?.model.closeModalHandler?()
				}
			)
		}

		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}

final class HandlerButton: UIButton {
	let tapHandler: () -> Void

	override var buttonType: UIButton.ButtonType {
		return .custom
	}

	override var intrinsicContentSize: CGSize {
		let original = super.intrinsicContentSize
		return .init(width: original.width + 25, height: original.height)
	}

	init(text: String, tapHandler: @escaping () -> Void) {
		self.tapHandler = tapHandler
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
		self.backgroundColor = .black
		self.setTitleColor(.white, for: .normal)
		self.setTitle(text, for: .normal)
		self.layer.cornerRadius = intrinsicContentSize.height / 2
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func tapAction() {
		tapHandler()
	}
}
