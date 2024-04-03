//
//  VCBookChapPicker.swift
//  FHLBible
//
//  Created by littlesnow on 2021/11/1.
//

import Foundation
import UIKit

/// 使用 initBeforePushVC
/// onClick$
public class VCBookChapPicker : UIViewController {
    public var onClick$: IjnEventOnce<UIView,(idBook:Int,idChap:Int)> = IjnEventOnce()
    public func initBeforePushVC(_ idBook:Int,_ idChap:Int){
        self.idBook = idBook
        self.idChap = idChap
    }
    private var settingOldTestment: [String] {
        get {
            let r1 = bookList
            return ijnRange(0, 39).map({r1[$0]}) // return ["創","出"]
        }
    }
    private var bookList: [String] {
        if isFullname {
            return get_booknames_via_tp(tp: ManagerLangSet.s.curIsGb ? .马太福音GB : .馬太福音)
        } else {
            return get_booknames_via_tp(tp: ManagerLangSet.s.curTpBookNameLang)
        }
        
    }
    private var settingNewTestment: [String] { ijnRange(39, 27).map({bookList[ $0]}) }
    @IBOutlet weak var btnFullname: UIButton!
    @IBOutlet weak var viewCollection : ViewButtons!
    /// 要上色，以表示 目前 active 用。
    @IBOutlet var btnOpts: [UIButton]!
    @IBAction func switchFullnameSetting(){
        if isFullname {
            isFullname = false
        } else {
            isFullname = true
        }
        
        // 更新，按下後，沒有反應很奇怪
        if btnOpt == .oldTestment {
            switchOldTestment()
        } else if btnOpt == .newTestment {
            switchNewTestment()
        } else if btnOpt == .hebrewOrder {
            switchHebrewOlder()
        }
    }
    private var idBook: Int = 2
    private var idChap: Int = 1
    public enum BtnOpt {
        case oldTestment
        case newTestment
        case chap
        case hebrewOrder
    }
    private var btnOpt: BtnOpt = .chap {
        didSet {
            updateBtnOptColor()
        }
    }
    @IBAction func switchToChap(){
        btnOpt = .chap
        
        if idBook >= 1 && idBook <= 66 {
            let cnt = BibleChapCount.getChapCount(self.idBook)
            let idInfos = ijnRange(1, cnt)
            let titles = idInfos.map({$0.description})
            viewCollection.setButtons(titles, idInfos, idChap - 1)
        } else {
            switchOldTestment()
        }
        
    }
    @IBAction func switchOldTestment(){
        btnOpt = .oldTestment
        
        let idInfos = ijnRange(1, 39)
        // 1 2 3 4 ... 若 idInfo 為 3， idxCur 為 [2]
        let idxCur = idBook - 1
        viewCollection.setButtons(settingOldTestment, idInfos, idxCur)
    }
    @IBAction func switchNewTestment(){
        btnOpt = .newTestment
        
        let idInfos = ijnRange(40, 27)
        // 40 41 42 43 ... 若 idInfo 為 42， idxCurrent 為 [2]
        let idxCur = idBook - 40
        viewCollection.setButtons(settingNewTestment, idInfos, idxCur)
        
        
    }
    @IBAction func switchHebrewOlder(){
        btnOpt = .hebrewOrder
        
        let r1 = bookList
        let r2 = BibleConstants.s.ORDER_OF_HEBREW
        let titles = r2.map({r1[$0 - 1]})
        // ... 27 15 13 14 ...
        let idxCur:Int = r2.firstIndex(of: idBook) ?? -1
        viewCollection.setButtons(titles, r2, idxCur)
    }
    private var isFullname: Bool = false {
        didSet {
            let r1 = isFullname ? "checkmark" : "xmark"
            btnFullname.setImage(UIImage(systemName: r1), for: .normal)
        }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCollection.onClick$.addCallback { sender, pData in
            if self.btnOpt != .chap {
                self.idBook = sender!.idInfo!
                if sinq( BibleChapCount.getChapCountEqual1BookIds() ).any({$0 == self.idBook}){
                    self.idChap = 1
                    self.navigationController?.popViewController(animated: false)
                    self.onClick$.triggerAndCleanCallback(self.view, (idBook: self.idBook, idChap: self.idChap))
                } else {
                    self.switchToChap()
                }
            } else {
                self.idChap = sender!.idInfo!
                self.navigationController?.popViewController(animated: false)
                self.onClick$.triggerAndCleanCallback(self.view, (idBook: self.idBook, idChap: self.idChap))
            }
        }
        
        setButtonFonSize()
        
        updateBtnOptColor()
        
        switchToChap()
    }
    func setButtonFonSize(){
        // 使用 fontMetrics 可隨系統設定的大小縮放
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let customFont = UIFont.systemFont(ofSize: 18.0)
        let scaledFont = fontMetrics.scaledFont(for: customFont)
        
        for a1 in btnOpts{
            a1.titleLabel?.font = scaledFont
        }
        btnFullname.titleLabel?.font = scaledFont
    }
    private func updateBtnOptColor(){
        self.btnOpts.forEach { btn in
            btn.setTitleColor(.systemBlue, for: .normal)
        }
        var r1: [BtnOpt:UIButton] = [:]
        r1[.oldTestment] = btnOpts[0]
        r1[.newTestment] = btnOpts[1]
        r1[.chap] = btnOpts[2]
        r1[.hebrewOrder] = btnOpts[3]
        r1[self.btnOpt]?.setTitleColor(.systemRed, for: .normal)
    }
}

extension UIViewController {
    /// 使用 initBeforePushVC、onClick$
    public func gVCBookChapPicker()->VCBookChapPicker { self.gEasyGetViewCtrlFromXibCore("VCBookChapPicker")}    
}
