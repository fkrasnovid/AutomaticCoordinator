
import UIKit

/// Абстракция от UIKit'a
public enum ModalTransitionStyle: Int {
	case coverVertical = 0
	case flipHorizontal = 1
	case crossDissolve = 2
	case partialCurl = 3

	internal var uiModalTransitionStyle: UIModalTransitionStyle {
		switch self {
		case .coverVertical: return .coverVertical
		case .flipHorizontal: return .flipHorizontal
		case .crossDissolve: return .crossDissolve
		case .partialCurl: return .partialCurl
		}
	}
}
