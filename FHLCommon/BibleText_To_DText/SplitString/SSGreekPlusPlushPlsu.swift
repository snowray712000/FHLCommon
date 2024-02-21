//
//  Reference.swift
//  FHLBible
//
//  Created by littlesnow on 2021/11/19.
//

import Foundation

public func ssDtGreekPlusPlusPlus(_ ds:[DText],_ ver: String? = nil )->[DText]{
    return doSSDTextCore(ds, {SSGreekPlusPlusPlus(ver)})
}

/// 顯示時用
open class SSGreekPlusPlusPlus : SplitStringDTextCore {
    public init(_ ver: String?){
        _ver = ver
    }
    open override var ovReg: NSRegularExpression { Self.reg1 }
    open override func ovGenerateDText(_ a1: SplitByRegexOneResult, _ cloneOfSrc: DText) -> DText {
        let reW = "(韋:\(a1.exec[1]!))(聯:\(String(a1.exec[2]!)))"
        cloneOfSrc.w = reW
        return cloneOfSrc
    }
    /// + 是特殊符號， + xxxx + xxxxx +
    static var reg1 = try! NSRegularExpression(pattern: #"\+([^\+]+)+\+([^\+]+)\+"#, options: [])
    private var _ver: String?
}

