import UIKit

/// Абстракция от UIKit'a
public protocol Presentable: AnyObject {
	var toPresent: UIViewController { get }
}

extension UIViewController: Presentable {
	public var toPresent: UIViewController { self }
}
