import Foundation
import FMDB


public protocol ISQLCBOLDictIsExist{
    /// 原本程式碼 SQLCBOLDict.isExist() ? SnDictDataCbolQOffline() : SnDictDataCbolQ()
    /// 重構，因為 SQL 沒有到 Common ， 但是有些又要重構到 Common 。
    func SQLCBOLDictisExist() -> Bool
}
/**
 因重構後，要另外傳入建構子參數 (已轉為 protocol)
 */
public class SnDictDataCbolQAuto {
    /**
     - Parameters:
        - iSQLCBOLDictIsExist: 應該是用 SQLCBOLDict.isExist()
        - iSQLCbolDict: 應該是用 SQLCBOLDict()
     */
    public init(_ iSQLCBOLDictIsExist:ISQLCBOLDictIsExist? = nil,_ iSQLCbolDict: ISQLCBOLDictDoSelect? = nil){
        self.iSQLCBOLDictIsExist = iSQLCBOLDictIsExist
        self.iSQLCbolDict = iSQLCbolDict
    }
    /// 重構在 protocol 才需要的，邏輯上不需要
    var iSQLCBOLDictIsExist :ISQLCBOLDictIsExist?
    /// 重構在 protocol 才需要的，邏輯上不需要
    var iSQLCbolDict: ISQLCBOLDictDoSelect?
    
    /// 第1個參數，若有錯誤訊息時，放在那
    var onApiFinished$: IjnEventOnce<[DText],DApiSd> = IjnEventOnce()
    fileprivate func triggerError(_ msg:String){
        self.onApiFinished$.triggerAndCleanCallback([DText(msg)], nil)
    }
    func mainAsync(_ dtext:DText){
        // let r1: SnDictDataCbolQAuto = SQLCBOLDict.isExist() ? SnDictDataCbolQOffline() : SnDictDataCbolQ()
        let r1: SnDictDataCbolQAuto = iSQLCBOLDictIsExist!.SQLCBOLDictisExist() ? SnDictDataCbolQOffline(self.iSQLCbolDict) : SnDictDataCbolQ()
        r1.onApiFinished$.addCallback { sender, pData in
            self.onApiFinished$.triggerAndCleanCallback(sender, pData)
        }
        r1.mainAsync(dtext)
    }
}
/// 查詢資料
class SnDictDataCbolQ : SnDictDataCbolQAuto {
    /// 第1個參數，若有錯誤訊息時，放在那
    override func mainAsync(_ dtext:DText){
        assert ( dtext.sn != nil && dtext.tp != nil )
        
        let N = dtext.tp == "H" ? 1 : 0
        
        let r1 =  "k=\(dtext.sn!)&\(ManagerLangSet.s.curQueryParamGb)&N=\(N)"
        
        fhlSd(r1) { data in
            if data.isSuccess() == false {
                self.triggerError("api失敗, 參數為 \(r1).")
            } else {
                if data.record.count == 0 {
                    self.triggerError("api成功, 但資料是空的, 參數為 \(r1)")
                } else {
                    self.onApiFinished$.triggerAndCleanCallback(nil, data)
                }
            }
        }
    }
    
    
}
/// 重構 SnDictDataCbolQOffline 到 FHLCommon 時需要。 因為 SQLCBOLDict 沒跟過來
public protocol ISQLCBOLDictDoSelect{
    func doSelect(stringOfSQLite cmd:String,
                args values:[Any]?,
                  CallbackWhenQueryed fnDo: (FMResultSet)->Void)->Bool;
    var lastErrorMessage:String? { get }
}
class SnDictDataCbolQOffline : SnDictDataCbolQAuto {
    /**
     為了使此 class 能編譯過，在 FHLCommon 專案，就將主專案才有的 class 變為 protocol 。
     */
    public init(_ iSQLCBOLDictDoSelect:ISQLCBOLDictDoSelect? = nil){
        self.iSQLCBOLDictDoSelect = iSQLCBOLDictDoSelect
    }
    var iSQLCBOLDictDoSelect :ISQLCBOLDictDoSelect?
    
    override func mainAsync(_ dtext:DText){
        guard let iSQLCBOLDictDoSelect = iSQLCBOLDictDoSelect else {
            self.triggerError("Assert iSQLCBOLDictDoSelect = SQLCBOLDict() ")
            return
        }
        
        assert ( dtext.sn != nil && dtext.tp != nil )
        let isOld = dtext.tp == "H" ? 1 : 0
        let snTool = SnSplitSuffix(dtext.sn!)
        let cmd = "select * from sndict2 where sn=\(snTool.sn!) and isOld=\(isOld) and snSuffix='\(snTool.snSuffix)';"
        
        // let objSQL = SQLCBOLDict() // 原本的
        let objSQL = iSQLCBOLDictDoSelect
        let re = objSQL.doSelect(stringOfSQLite: cmd, args: nil) { (a1:FMResultSet) in
            if ( a1.next() ){
                let txt = a1.string(forColumn: "txt")
                let orig = a1.string(forColumn: "orig")
                let sn = a1.int(forColumn: "sn")
                let suf = a1.string(forColumn: "snSuffix")
                let isOld = a1.int(forColumn: "isOld")
                
                let re = DApiSd()
                re.status = "success"
                re.record = []
                
                let r1 = DApiSdRecord()
                r1.sn = "\(sn)\(suf!)"
                r1.orig = orig
                r1.dic_text = txt
                r1.edic_text = ""
                r1.dic_type = Int( isOld)
                re.record.append(r1)
                
                self.onApiFinished$.triggerAndCleanCallback(nil, re)
            } else {
                self.triggerError("select 成功, 但資料是空的. 查詢的字: \(dtext.w!)")
            }
        }
        if re == false {
            self.triggerError("SQL失敗, 錯誤資訊為 \(objSQL.lastErrorMessage!).")
        }
    }
}

/// 因為 SQL 的 Sn Dict 是正規化的，但是原本的字是 2132a 時，就要切割
public class SnSplitSuffix{
    static var reg = try! NSRegularExpression(pattern: "([\\d]+)([a-zA-Z]*)", options: [])
    public init(_ snWithSuffix:String){
        main(snWithSuffix)
    }
    public var sn: Int!
    /// "" or 'a' 不會是 nil
    public var snSuffix: String = ""
    func main(_ snWithSuffix:String){
        let r2 = ijnMatchFirstAndToSubString(Self.reg, snWithSuffix)
        if r2![2] != nil {
            snSuffix = String(r2![2]!)
        } else {
            snSuffix = ""
        }
        
        sn = Int(r2![1]!)
    }
}
