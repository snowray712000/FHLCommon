/**
 一定會有，取得清單的需求，選取書卷時就可能用到。尤其還要依目前語言設定，會取得不同版本時。
 */
import Foundation
public func get_booknames_via_tp(tp: BookNameLang)->[String]{
    return BookNameConstants.getNameArrayViaLanguageType(tp)
}

extension BookNameConstants {
    /// 在 BibleBookNames 中用，直覺它會再被使用，先抽出來
    static func getNameArrayViaLanguageType(_ tp: BookNameLang)->[String]{
        var ref: [String] = BookNameConstants.CHINESE_BOOK_ABBREVIATIONS
        if ( tp == .太GB ) {
            ref = BookNameConstants.CHINESE_BOOK_ABBREVIATIONS_GB
        } else if ( tp == .马太福音GB) {
            ref = BookNameConstants.CHINESE_BOOK_NAMES_GB
        } else if ( tp == .馬太福音 ){
            ref = BookNameConstants.CHINESE_BOOK_NAMES
        } else if ( tp == .Mt ){
            ref = BookNameConstants.ENGLISH_BOOK_SHORT_ABBREVIATIONS
        } else if ( tp == .Matt){
            ref = BookNameConstants.ENGLISH_BOOK_ABBREVIATIONS
        } else if ( tp == .Matthew){
            ref = BookNameConstants.ENGLISH_BOOK_NAMES
        }
        return ref
    }
}
