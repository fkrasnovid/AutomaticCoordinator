
import UIKit

/// Абстракция от UIKit'a
public enum ModalPresentationStyle: Int {
	case fullScreen = 0
	case pageSheet = 1
	case formSheet = 2
	case currentContext = 3
	case custom = 4
	case overFullScreen = 5
	case overCurrentContext = 6
	case popover = 7
	case none = -1

	@available(iOS 13.0, *)
	case automatic = -2

	internal var uiModalPresentationStyle: UIModalPresentationStyle {
		switch self {
		case .fullScreen: return .fullScreen
		case .pageSheet: return .pageSheet
		case .formSheet: return .formSheet
		case .currentContext: return .currentContext
		case .custom: return .custom
		case .overFullScreen: return .overFullScreen
		case .overCurrentContext: return .overCurrentContext
		case .popover: return .popover
		case .none: return .none
		case .automatic:
			if #available(iOS 13.0, *) {
				return .automatic
			} else {
				return .fullScreen
			}
		}
	}
}
