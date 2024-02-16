//
//  uiabv.swift
//  FHLBible
//
//  Created by snowray712000@gmail.com on 2021/11/3.
// 請參考 qsb 實作新的, 這個也是參考那個作的
import Foundation

/// CBOL 字典, sd 的 d 應該是指 dictionary
/// k=03615&gb=0&N=1
public func fhlSd(_ param: String,_ fn: @escaping FhlJson<DApiSd>.FnCallback) {
    fhlCore(param, "sd", fn)
}

public class DApiSd : FhlJsonResult {
    enum CodingKeys: String,  CodingKey {
        case record
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        record = try container.decode([OneRecord].self, forKey: .record)
        record.forEach({$0.sn = removeSn000($0.sn!)})
        
        try super.init(from: decoder)
    }
    public required init(_ status: String = "") {
        record = []
        super.init(status)
    }
    public var record: [OneRecord]
    public typealias OneRecord = DApiSdRecord
}
public class DApiSdRecord : Decodable {
    /// "03615"
    public var sn:String?
    public var dic_text:String?
    public var edic_text:String?
    /// 0: 新約 1:舊約
    public var dic_type:Int?
    /// 原文
    public var orig:String?
    
    public init(){}
}

///
public func removeSn000(_ a1:String?)-> String? {
    if a1 == nil { return nil }
    return ijnReplaceString(try! NSRegularExpression(pattern: #"^[0]*"#, options: []), a1!, "")
}
