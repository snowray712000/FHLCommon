//
//  range.swift
//  FHLCommon
//
//  Created by littlesnow on 2024/2/5.
//

import Foundation
public func range(_ start: Int, _ count: Int,_ delta: Int = 1)->[Int] {
    return ijnRange(start, count, delta)
}
/// Linq Range
/// - Parameters:
///   - start: start
///   - count: count
///   - delta: 當1的時候，核心是用 Range 產生。
/// - Returns: 陣列
public func ijnRange(_ start:Int,_ count:Int,_ delta:Int = 1)-> [Int] {
    if (delta==1){
        return Array(start..<(start+count))
    }
    var r1 = start
    var cnt = 0
    var re: [Int]=[]
    while ( cnt < count ){
        re.append(r1)
        r1 += delta
        cnt += 1
    }
    return re
}
