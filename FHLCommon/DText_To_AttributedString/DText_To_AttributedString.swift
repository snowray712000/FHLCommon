//
//  DText_To_AttributedString.swift
//  FHLCommon
//
//  Created by littlesnow on 2024/2/2.
//

import Foundation

/**
 - Parameters:
    - isSnVisible: 有的需要將 Sn 顯示出來
    - isTCSupport: 特殊的資料結構，需要特殊的 Font 才行。例如，台語、客語某些字會出問題
 */
public func DText_To_AttributedString(dtexts: [DText],isSnVisible: Bool, isTCSupport: Bool) -> NSMutableAttributedString {
    let r1 = DTextDrawToAttributeString(isSnVisible, isTCSupport).mainConvert(dtexts)
    
    let re = NSMutableAttributedString()
    for a1 in r1{
        re.append(a1)
    }
    return re
}
