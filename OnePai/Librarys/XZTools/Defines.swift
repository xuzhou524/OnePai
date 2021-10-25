//
//  Defines.swift
//  KaiXinGuo
//
//  Created by xuzhou on 2018/12/21.
//  Copyright © 2018 Gozap. All rights reserved.
//

import UIKit

/// 将代码安全的运行在主线程
public func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

//屏幕宽高
public let kScreenWidth  = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height
//是否刘海屏幕
public let kIsFullScreen = (UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 ? true : false)

public func XZFontWithSize(_ size:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: size)
}
public func XZBlodFontWithSize(_ size:CGFloat) -> UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}
public func XZLightFontWithSize(_ size:CGFloat) -> UIFont{
    UIFont.systemFont(ofSize: size, weight: .thin)
    return UIFont(name: "Helvetica-Light", size: size)!
}
public func XZWeightFontWithSize(_ size:CGFloat, weight:UIFont.Weight) -> UIFont{
    return UIFont.systemFont(ofSize: size, weight: weight)
}

public let kHalfPixel = 1 / UIScreen.main.scale

public extension Int {
    var money:String {
        get {
            if self >= 10000000 {
                return String(format: "%.2f", Double(self) / 100.0)
            }
            return String(format: "%g", Double(self) / 100.0)
        }
    }
}

extension UIView {
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移量
    ///   - opacity: 阴影透明度
    ///   - radius: 阴影半径
    func addShadow(color: UIColor, offset:CGSize, opacity:Float, radius:CGFloat) {
//        self.layer.masksToBounds = true
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        
        let shadowRect: CGRect? = CGRect.init(x: -radius, y: -radius, width: bounds.size.width + 2 * radius, height: bounds.size.height + 2 * radius)

        self.layer.shadowPath = UIBezierPath.init(rect: shadowRect!).cgPath
    
    }
    
    func addRoundedCorners(corners:UIRectCorner,radii:CGSize,rect:CGRect) {
        let rounded = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    //截图
    public func ts_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

extension String {
    //1, 截取规定下标之后的字符串
    public func subStringFrom(index: Int)-> String {
        let temporaryString: String = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[temporaryIndex...])
    }
    
    //2, 截取规定下标之前的字符串
    public func subStringTo(index: Int) -> String {
        let temporaryString = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[...temporaryIndex])
        
    }
    
    public func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    public func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    /// 从String中截取出参数
    public var urlParameters: [String: AnyObject]? {
        // 截取是否有参数
        guard let urlComponents = NSURLComponents(string: self), let queryItems = urlComponents.queryItems else {
            return nil
        }
        // 参数字典
        var parameters = [String: AnyObject]()
        // 遍历参数
        queryItems.forEach({ (item) in
            // 判断参数是否是数组
            if let existValue = parameters[item.name], let value = item.value {
                // 已存在的值，生成数组
                if var existValue = existValue as? [AnyObject] {
                    existValue.append(value as AnyObject)
                }else{
                    parameters[item.name] = [existValue, value] as AnyObject
                }
            }else{
                parameters[item.name] = item.value as AnyObject
            }
        })
        return parameters
    }
}

// MARK: - 按钮的反复点击问题 交换方法
extension UIButton {
    /// 对外交换方法的方法 AppDelegate Launch中使用
    public  static func methodExchange() {
        DispatchQueue.once(token: "UIButton") {
            let originalSelector = Selector.sysFunc
            let swizzledSelector = Selector.myFunc
            changeMethod(originalSelector, swizzledSelector, self)
        }
    }
    /// Runtime方法交换
    ///
    /// - Parameters:
    ///   - original: 原方法
    ///   - swizzled: 交换方法
    ///   - object: 对象
    public static func changeMethod(_ original: Selector, _ swizzled: Selector, _ object: AnyClass) -> () {
        guard let originalMethod = class_getInstanceMethod(object, original),
              let swizzledMethod = class_getInstanceMethod(object, swizzled) else {
            return
        }
        let didAddMethod = class_addMethod(object, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(object, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    /// 结构体静态key
    public struct UIButtonKey {
        static var isEventUnavailableKey = "isEventUnavailableKey"
        static var eventIntervalKey = "eventIntervalKey"
    }
    
    /// 触发事件的间隔
    public var eventInterval: TimeInterval {
        get {
            return (objc_getAssociatedObject(self, &UIButtonKey.eventIntervalKey) as? TimeInterval) ?? 1
        }
        set {
            objc_setAssociatedObject(self, &UIButtonKey.eventIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否可以触发事件
    public var isEventUnavailable: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIButtonKey.isEventUnavailableKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIButtonKey.isEventUnavailableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 手写的set方法
    ///
    /// - Parameter isEventUnavailable: 事件是否可用
    @objc public func setIsEventUnavailable(_ isEventUnavailable: Bool) {
        self.isEventUnavailable = isEventUnavailable
    }
    
    /// mySendAction
    @objc public func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if isEventUnavailable == false {
            isEventUnavailable = true
            mySendAction(action, to: target, for: event)
            perform(#selector(setIsEventUnavailable(_: )), with: false, afterDelay: eventInterval)
        }
    }
}

fileprivate extension Selector {
    static let sysFunc = #selector(UIButton.sendAction(_:to:for:))
    static let myFunc = #selector(UIButton.mySendAction(_:to:for:))
}

extension DispatchQueue {
    public static var onceTracker = [String]()
    open class func once(token: String, block:() -> ()) {
        //注意defer作用域，调用顺序——即一个作用域结束，该作用域中的defer语句自下而上调用。
        objc_sync_enter(self)
        defer {
            print("线程锁退出")
            objc_sync_exit(self)
        }
        
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
        do {
            print("block执行完毕")
        }
    }
}
