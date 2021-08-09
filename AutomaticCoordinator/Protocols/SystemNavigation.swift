
import UIKit

/// Интерфейс для сущности UINavigationController в системе
public protocol SystemNavigation: UINavigationController {
	var popToRootHandler: (() -> Void)? { get set }
	var popHandler: (() -> Void)? { get set }
}
