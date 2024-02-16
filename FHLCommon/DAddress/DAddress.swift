//
//  DAddress.swift
//  FHLCommon
//
//  Created by littlesnow on 2024/2/2.
//

import Foundation
public class DAddress {
    public var book: Int
    public var chap: Int
    public var verse: Int
    
    public init(book: Int = 0, chap: Int = 0, verse: Int = 0) {
        self.book = book
        self.chap = chap
        self.verse = verse
    }
    public init(_ book: Int=0, _ chap: Int = 0,_ verse:Int = 0){
        self.book = book
        self.chap = chap
        self.verse = verse
    }
}
/// 當要用 Set<DAddress> 時會用到
extension DAddress : Hashable {
    /// Type 'DAddress' does not conform to protocol 'Hashable'
    public func hash(into hasher: inout Hasher) {
        hasher.combine(book)
        hasher.combine(chap)
        hasher.combine(verse)
    }
}
/// 呼叫排序時 .sort （＜）　或　.sort（＞） r2.sort(by:＜)
extension DAddress : Equatable, Comparable {
    public static func < (lhs: DAddress, rhs: DAddress) -> Bool {
        if lhs.book < rhs.book { return true }
        if lhs.chap < rhs.chap { return true }
        if lhs.verse < rhs.verse { return true }
        return false
    }
    public static func == (lhs: DAddress, rhs: DAddress) -> Bool {
        return lhs.book == rhs.book && lhs.chap == rhs.chap && lhs.verse == rhs.verse
    }
}
//extension DAddress {
//    public func toString(_ tp: BookNameLang)->String{
//        if ( book < 1 || book > 66){
//            return "\(book) \(chap):\(verse)"
//        }
//        
//        let na = BibleBookNames.getBookName(book, tp)
//        
//        return "\(na) \(chap):\(verse)"
//    }
//}

