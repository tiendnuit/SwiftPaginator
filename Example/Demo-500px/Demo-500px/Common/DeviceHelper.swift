
import UIKit

private extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

private func systemVersion() -> Float {
    return UIDevice.currentDevice().systemVersion.floatValue
}

public func IS_OS_7_OR_LATER() -> Bool {
    return systemVersion() >= 7.0
}

public func IS_OS_8_OR_LATER() -> Bool {
    return systemVersion() >= 8.0
}

//public func deviceID() -> String {
//    return UIDevice.currentDevice().identifierForVendor.UUIDString
//}

public func IS_IPHONE() -> Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Phone
}

public func IS_IPAD() -> Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD_NON_RETINA = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_RETINA = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 2048.0
}
