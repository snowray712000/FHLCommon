import Foundation
extension DAddress {
    ///
    /**
     產生整章 DAddress, 用 book, chap 參教
     - 實作 VCRead 時，選完書卷與章節，通常只有 book, chap，此時就需要產生此章所有節作為 addresses
     */
    public func generateEntireThisChap()->[DAddress] {
        let r1 = BibleVerseCount.getVerseCount(self.book, self.chap)
        return ijnRange(1, r1).map({DAddress(book: self.book, chap: self.chap, verse: $0)})
    }
}
