import Foundation
import UIKit
import CoreData

public protocol IAutoLoadDuiabvSQLite {
    /// 0, 非 gb 版, 1 gb 版, 只有 record 的資料是有存的
    func load()->(DApiUiabv?,DApiUiabv?)
    func update(_ re:DApiUiabv,_ reGb:DApiUiabv)
}

/**
    載入譯本，通常在程式開始時，只執行一次。 這個會嘗試從快取中取得，接著若可連接線上，則會更新快取。
 - Note:
    - 會在需要 initial 的地方使用 ` _ = AutoLoadDUiabv.s ` 來初始化。因為它是一個 lazy load 物件。
    - 這裡面有一個 AutoLoadDuiabvSQLite 是從 SQLite 取得用的。
 */
public class AutoLoadDUiabv {
    public static var s = AutoLoadDUiabv()
    public func reloadAsync(){
        /// 嘗試從 cache 取得
        let sq = _isq.load()
        if sq.0 != nil && sq.1 != nil {
            self._reApi = sq.0
            self._reApiGb = sq.1
            print ("uiabv init from sqlite.")
        }

        /// 開始取得
        let group = DispatchGroup()
        group.enter()
        fhlUiabv("") { data in
            if data.isSuccess() { // 網路不通時，不可取代已有的資料
                self._reFromApi = data
            }
            group.leave()
        }
        group.enter()
        fhlUiabv("gb=1") { data in
            if data.isSuccess() {
                self._reFromApiGb = data
            }
            group.leave()
        }

        // 取得後更新
        group.notify(queue: .main){
            if self._isSuccessApi() {
                self._updateSqFromApiResult()
                self._replaceReUsingApiResult()
            }
        }
    }
    public init () {
        reloadAsync()
    }
    /// 因為重構而來的
    public static var fnGFromSQLite: FnGenerateFromSQLite!
    public typealias FnGenerateFromSQLite = ()->IAutoLoadDuiabvSQLite
    /// var _isq: IAutoLoadDuiabvSQLite = AutoLoadDuiabvSQLite()
    private var _isq: IAutoLoadDuiabvSQLite = AutoLoadDUiabv.fnGFromSQLite()
    private var _reApi: DApiUiabv?
    private var _reApiGb: DApiUiabv?

    private var _reFromApi: DApiUiabv?
    private var _reFromApiGb: DApiUiabv?
    private func _isSuccessApi() -> Bool {
        let r1: [DApiUiabv?] = [_reFromApi, _reFromApiGb]
        if sinq(r1).any({$0 == nil}) { return false }

        let r2 = r1.map({$0!})
        if sinq(r2).any({$0.isSuccess()==false || $0.record!.count == 0} ){return false }

        return true
    }
    private func _updateSqFromApiResult(){
        _isq.update(self._reFromApi!, self._reFromApiGb!)
    }
    private func _replaceReUsingApiResult(){
        _reApi = _reFromApi
        _reApiGb = _reFromApiGb
    }

    public func dateOfComment(isGb:Bool)-> Date? {
        if isGb{
            return _reApiGb?.getComment()
        }
        return _reApi?.getComment()
    }
    public func dataOfParsing(isGb:Bool)->Date? {
        if isGb {
            return _reApiGb?.getParsing()
        }
        return _reApi?.getParsing()
    }
    public var record: [DUiAbvRecord] { recordcore(gb: false) }
    public var recordGb: [DUiAbvRecord] { recordcore(gb: true) }
    private func recordcore(gb:Bool)->[DUiAbvRecord]{
        let _reApi = gb ? self._reApiGb : self._reApi
        if (_reApi == nil || _reApi!.record == nil ){
            return []
        }
        return _reApi!.record!
    }
}
