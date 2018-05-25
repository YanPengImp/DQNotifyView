//
//  Timer+DQCallback.swift
//  DQNotifyView
//
//  Created by Imp on 2018/5/25.
//  Copyright © 2018年 jingbo. All rights reserved.
//

import Foundation

extension Timer {
    class func dq_scheduledTimer(timeInterval ti: TimeInterval, repeats yesOrNo: Bool, callback: @escaping (Timer)->()) -> Timer {
        let target = DQTimerWeakTarget()
        return target.scheduledTimer(timeInterval: ti, repeats: yesOrNo, callback: callback)
    }
}


class DQTimerWeakTarget: NSObject {
    var targetCallback: ((Timer)->())?
    weak var targetTimer: Timer?

    func scheduledTimer(timeInterval ti: TimeInterval, repeats yesOrNo: Bool, callback: @escaping (Timer)->()) -> Timer {
        targetCallback = callback
        let timer = Timer.scheduledTimer(timeInterval: ti, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: yesOrNo)
        targetTimer = timer
        return timer
    }

    @objc func timerCallback() {
        targetCallback?(targetTimer!)
    }
}
