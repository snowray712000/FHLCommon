/// `「哥林多前書」是第幾卷書？` 這樣的問題，是需要一個函式的，反過來，則不太需要。回傳是 1-based 唷。

import Foundation
/**
 - returns:
    - 「創」「創世記」「Ge」「Gen」各種，都會判定是 1。1-based
    - 若不存在，則回傳 -1，而非 0。
 */
public func get_id_from_bookname(_ nameLowcase: String)-> Int {
    return BookNameAndId().getIdOrUndefined(nameLowcase) ?? -1
}
/**
    有更好的效率優化
 - returns:
    - 「創」「創世記」「Ge」「Gen」各種，都會判定是 1。1-based
    - 若不存在，則回傳 -1，而非 0。
 */
public func get_id_from_bookname(_ nameLowcase: String, tp: BookNameLang)-> Int {
    return BibleBookNameToId().main1based(tp, nameLowcase)
}



