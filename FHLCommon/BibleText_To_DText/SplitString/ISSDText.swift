import Foundation

/// 若沒有任何改變，就回傳 nil
/// 不能處理 (w是空的)，所以使用此，不用再加 w? 判斷
/// 參考 SSRef class
public protocol ISSDText {
    func main(_ src: DText) -> [DText]?
}
