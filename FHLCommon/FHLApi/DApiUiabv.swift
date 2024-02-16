//
//  DApiUiabv.swift
//  FHLCommon
//
//  Created by littlesnow on 2024/2/5.
//

import Foundation

/// 用 auto load duiabv ， 不要用這個
/// 因為這個程式一開始就執行了一次這個
public func fhlUiabv(_ param: String,_ fn: @escaping FhlJson<DApiUiabv>.FnCallback) {
    fhlCore(param, "uiabv", fn)
}

public class DApiUiabv : FhlJsonResult {
    private enum CodingKeys: String, CodingKey {
        case record
        case parsing
        case comment
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        parsing = try? container.decode(String.self, forKey: .parsing)
        comment = try? container.decode(String.self, forKey: .comment)
        record = try? container.decode([OneRecord].self, forKey: .record)
        
        try super.init(from: decoder)
        
        // Decodable 在 class 繼承時，子類別不如預期的，會轉換成功 https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
    }
    
    required public init(_ status: String = "") {
        record = []
        super.init(status)
    }
    public var parsing : String?
    public var comment : String?
    public var record : [OneRecord]?
    
    public func getParsing () -> Date? { return Date.ijnFromStr(parsing) }
    public func getComment () -> Date? { return Date.ijnFromStr(comment) }
    
    public typealias OneRecord = DUiAbvRecord
}

public class DUiAbvRecord : Decodable {
    public init(_ na:String = ""){
        self.book = na
    }
    public var book : String
    public var cname : String?
    public var version : String?
    public var proc : Int?
    public var strong : Int?
    public var ntonly : Int?
    public var candownload : Int?
    public var otonly: Int?
    
    public func getVersion () -> Date? { return Date.ijnFromStr(version) }
}
