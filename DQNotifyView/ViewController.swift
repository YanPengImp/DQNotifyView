//
//  ViewController.swift
//  DQNotifyView
//
//  Created by Imp on 2018/5/25.
//  Copyright © 2018年 jingbo. All rights reserved.
//

import UIKit

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(integerLiteral: i * 7)) {
                self.showNotifyView(i)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    func showNotifyView(_ i: Int) {
        let item = DQNotifyItem()
        item.title = String(format: "新消息：%d", i)
        item.content = String(format: "这是一条测试的新消息：%d", i)
        item.clickBlock =  {
            print("点击事件")
        }
        DQNotifyManager.shared.showNotifyView(item)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

