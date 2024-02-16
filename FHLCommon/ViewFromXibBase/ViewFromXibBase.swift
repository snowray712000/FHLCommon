//
//  ViewSearchResult.swift
//  FHLBible
//
//  Created by littlesnow on 2021/10/23.
//

import UIKit
/// 因為 gVCVerseActionPicker gVCSearchResult 都會用到 重構
public func easyGetViewCtrlFromXibCore<T>(_ idOfStoryboard:String ,_ ctrl:UIViewController) -> T where T: UIViewController {
    return ctrl.storyboard!.instantiateViewController(withIdentifier: idOfStoryboard) as! T
}

public class ViewFromXibBase : UIView {
    @IBOutlet var viewBase: UIView!
    public var bundleForInit: Bundle { Bundle(for: type(of: self)) }
    public var nibName: String { "ViewFromXibBase" }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initFromXib()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initFromXib()
    }
    public func initFromXib(){
        bundleForInit.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(viewBase)
        viewBase.add4ConstrainsWithSuperView()
        viewBase.frame.size = self.frame.size
        
        initedFromXib()
    }
    public func initedFromXib(){}
}

extension UIViewController {
    public func gEasyGetViewCtrlFromXibCore<T>(_ idOfStoryboard:String)->T where T:UIViewController { self.storyboard!.instantiateViewController(withIdentifier: idOfStoryboard) as! T }
}
