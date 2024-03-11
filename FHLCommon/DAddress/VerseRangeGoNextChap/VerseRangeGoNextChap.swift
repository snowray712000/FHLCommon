//
//  VerseRangeGoNextChap.swift
//  FHLCommon
//
//  Created by littlesnow on 2024/3/11.
//

import Foundation
/// 按 goNext 按鈕時，要用到的
/// 可以直接用 VerseRange.goNext 與 .goPrev
public class VerseRangeGoNextChap: NSObject {
    public typealias VerseRange = [DAddress]
    public func goPrev(_ a:VerseRange)->VerseRange {
        
        if a.count == 0 { return vDefault }
        
        let r1 = a[0]
        
        let bk = r1.book
        let ch = r1.chap
        if ch == 1 {
            // 換書卷
            if bk == 1 {
                return gChap(66, BibleChapCount.getChapCount(66))
            } else {
                return gChap(bk-1, BibleChapCount.getChapCount(bk-1))
            }
        } else {
            return gChap(bk, ch-1)
        }
    }
    public func goNext(_ a:VerseRange)->VerseRange {
        if a.count == 0 { return vDefault }
        
        let r1 = a[0]
        
        let bk = r1.book
        let ch = r1.chap
        let cntThisBk = BibleChapCount.getChapCount(bk)
        if ch != cntThisBk {
            return gChap(bk, ch+1)
        } else {
            // 換書卷
            if bk == 66 {
                return gChap(1, 1)
            } else {
                return gChap(bk+1, 1)
            }
        }
    }
    fileprivate func gChap(_ bk:Int, _ ch: Int) -> [DAddress] {
        return DAddress(book: bk, chap: ch, verse: 1).generateEntireThisChap()
    }
    fileprivate var vDefault: VerseRange {
        get {
            return [DAddress(book: 45, chap: 1, verse: 1)]
        }
    }
}
