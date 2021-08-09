
import UIKit

/// Абстракция от UIKit'a
public protocol Transition: AnyObject {
	var transitioning: UIViewControllerAnimatedTransitioning { get }
}
