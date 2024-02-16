//
//  ViewSearchResult.swift
//  FHLBible
//
//  Created by littlesnow on 2021/10/23.
//

import UIKit

extension UIView {
    public func add4ConstrainsWithSuperView(){
        if self.superview == nil {
            return
        }
        
        let pv = self.superview!
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: pv.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: pv.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: pv.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: pv.bottomAnchor).isActive = true
    }
    
}
