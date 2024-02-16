import Foundation
public class BibleBookNameToId {
    public init(){}
    /// 若沒有找到，回傳 -1
    /// 已經優化過效率，是用 dictionary，並且作為 static 了。
    public func main1based(_ tp: BookNameLang,_ str: String)-> Int {
        var r1 = Self.dicts[tp]
        if r1 == nil {
            r1 = generateOneDict(tp)
            Self.dicts[tp] = r1!
        }
        
        let r2 = r1![str]
        return r2 != nil ? r2! : -1
        
        //let r1 =  BibleBookNames.getBookNames(tp)
        //let r2 = r1.ijnIndexOf(str)
        //return r2 != nil ? r2! + 1 : -1
    }
    /// na : bookId
    typealias OneDict = [String:Int]
    static var dicts: [BookNameLang : OneDict ] = [:]
    
    func generateOneDict(_ tp:BookNameLang)->OneDict{
        let r2 = get_booknames_via_tp(tp: tp)
        var re: OneDict = [:]
        for (i,a2) in r2.enumerated() {
            re[a2] = i + 1 // 1-based
        }
        return re
    }
}
