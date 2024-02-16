//
//  ViewSearchResult.swift
//  FHLBible
//
//  Created by littlesnow on 2021/10/23.
//

import UIKit

extension UIView {
    /// 經實驗，一般新增 constrains 不會自動把重複的去掉，所以加了這個函式
    public func removeContrainsRelativeMe(){
        let v2 = self.superview
        if v2 != nil {
            // 主要是第1個，第2個只是個險起見
            // 實驗後， constrains 沒有自動幫你把重複的自動移除
            v2!.removeConstraints(v2!.constraints.filter({$0.firstItem as? UIView == self}))
            v2!.removeConstraints(v2!.constraints.filter({$0.secondItem as? UIView == self}))
        }
        
        // 注意，不是 v 的 constraints 就全部都是與自己相關，可能是 v 的 兩個 children
        self.removeConstraints(self.constraints.filter({$0.firstItem as? UIView == self}))
    }
}
