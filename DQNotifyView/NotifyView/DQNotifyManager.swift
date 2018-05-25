//
//  DQNotifyManager.swift
//  DQGuess
//
//  Created by Imp on 2018/5/24.
//  Copyright © 2018年 jingbo. All rights reserved.
//

import UIKit

let kDQNotifyWindowHeight: CGFloat = 58
let DQAPPDelegateWindow = (UIApplication.shared.delegate?.window!)!

class DQNotifyManager: NSObject {
    static let shared = DQNotifyManager()
    var notifyWindow: UIWindow?

    override init() {
        super.init()
        notifyWindow = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kDQNotifyWindowHeight + DQAPPDelegateWindow.layoutInsets().top))
        notifyWindow?.windowLevel = UIWindowLevelStatusBar + 100
        notifyWindow?.backgroundColor = .clear
        notifyWindow?.rootViewController = UIViewController()
        notifyWindow?.isHidden = true
    }

    func showNotifyView(_ item: DQNotifyItem) {
        notifyWindow?.isHidden = false
        let view = DQNotifyView()
        view.notifyItem = item
        self.notifyWindow?.rootViewController?.view.addSubview(view)
        view.showWithComplete {

        }
        view.didDisappear = {
            self.notifyWindow?.isHidden = true
        }
    }
}

extension UIWindow {
    func layoutInsets() ->UIEdgeInsets {
        if #available(iOS 11, *) {
            if UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.height == 812 {
                return DQAPPDelegateWindow.safeAreaInsets
            }
            return UIEdgeInsetsMake(20, 0, 0, 0)
        }
        return UIEdgeInsetsMake(20, 0, 0, 0)
    }
}

