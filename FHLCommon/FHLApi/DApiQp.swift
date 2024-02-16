//
//  uiabv.swift
//  FHLBible
//
//  Created by snowray712000@gmail.com on 2021/11/3.
// 請參考 qsb 實作新的, 這個也是參考那個作的
import Foundation

public func fhlQp(_ param: String,_ fn: @escaping FhlJson<DApiQp>.FnCallback) {
    fhlCore(param, "qp", fn)
}
public class DApiQpRecord : Decodable {
    public init(){}
    public var remark: String? = ""
    public var chineses: String? = ""
    public var chinesef: String? = ""
    public var word: String? = "" // 顯示
    public var orig: String? = "" // 原型
    public var exp: String? = "" // 簡義
    public var pro: String? = "" // 詞性，例如 受詞 名詞(新約會有)
    public var wform: String? = "" // 詞性分析
    public var id: Int? = 0
    public var engs: String? = "" // Gen
    public var chap: Int? = 0 // 1
    public var sec: Int? = 0 // 1
    public var wid: Int? = -1 // 0 就是非字典
    public var sn: String? = ""
}
public class DApiQp : FhlJsonResult {
    private enum CodingKeys: String, CodingKey {
        case record
        case N
        case next
        case prev
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        record = try container.decode([OneRecord].self, forKey: .record)
        N = try? container.decode(Int.self, forKey: .N)
        prev = try? container.decode(PrevNext.self, forKey: .prev)
        next = try? container.decode(PrevNext.self, forKey: .next)
        
        try super.init(from: decoder)
        
        // Decodable 在 class 繼承時，子類別不如預期的，會轉換成功 https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
    }
    
    required public init(_ status: String = "") {
        record = []
        super.init(status)
    }
    public var record : [OneRecord]
    public typealias OneRecord = DApiQpRecord
    var N: Int?
    public var prev: PrevNext?
    public var next: PrevNext?
    public func isOldTestment()->Bool{return N==1}
    
    public class PrevNext : Decodable {
        public var engs: String? = ""
        public var chineses: String? = ""
        public var chap: Int? = 0
        public var sec: Int? = 0
    }
    
}
