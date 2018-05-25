//
//  DQNotifyView.swift
//  DQGuess
//
//  Created by Imp on 2018/5/24.
//  Copyright © 2018年 jingbo. All rights reserved.
//

import UIKit
import SnapKit

let kDQNotifyTimeInterval: TimeInterval = 5

class DQNotifyView: UIView, UIGestureRecognizerDelegate {
    private var icon: UIImageView?
    private var titleLabel: UILabel?
    private var contentLabel: UILabel?
    private var timer: Timer?
    private var offset: CGFloat = 0
    var notifyItem: DQNotifyItem? {
        didSet {
            refreshViews()
        }
    }
    var didDisappear: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func refreshViews() {
        if let item = notifyItem {
            icon?.image = item.icon ?? UIImage.init(named: "message_ic_prompt")
            titleLabel?.text = item.title
            contentLabel?.text = item.content
        }
    }

    private func initViews() {
        self.isExclusiveTouch = true
        self.clipsToBounds = false
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        icon = UIImageView()

        icon?.image = UIImage.init(named: "message_ic_prompt")
        self.addSubview(icon!)
        icon!.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.bottom.equalTo(-19)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }

        titleLabel = UILabel()
        titleLabel!.textColor = UIColor(red: 130, green: 136, blue: 153, alpha: 1)
        titleLabel!.font = UIFont.systemFont(ofSize: 14)
        titleLabel!.text = "新消息："
        self.addSubview(titleLabel!)
        titleLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(icon!.snp.right).offset(10)
            make.top.equalTo(icon!)
        }

        contentLabel = UILabel()
        contentLabel!.textColor = UIColor(red: 235, green: 236, blue: 254, alpha: 1)
        contentLabel!.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(contentLabel!)
        contentLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel!)
            make.bottom.equalTo(icon!.snp.bottom).offset(-4)
            make.right.equalTo(-24)
        }

        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_:)))
        pan.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if self.superview != nil {
            self.snp.makeConstraints { (make) in
                make.height.left.right.equalToSuperview()
                make.bottom.equalTo(self.superview!.snp.top)
            }
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if timer == nil {
            return false
        }
        return true
    }

    func showWithComplete(_ complete: (()->Void)?) {
        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform.init(translationX: 0, y: self.bounds.size.height)
        }) { (finished) in
            complete?()
            self.timer = Timer.dq_scheduledTimer(timeInterval: kDQNotifyTimeInterval, repeats: false, callback: { (timer) in
                UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
                    self.transform = CGAffineTransform.identity
                }) { (finished) in
                    self.didDisappear?()
                    self.timer?.invalidate()
                    self.timer = nil
                    self.removeFromSuperview()
                }
            })
        }
    }

    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            if timer != nil {
                timer?.fireDate = Date.distantFuture
            }
            let offset1 = gesture.location(in: self.superview!).y
            let offset2 = gesture.location(in: self).y
            offset = offset1 - offset2
        } else if gesture.state == .changed{
            let translation = gesture.translation(in: self.superview!).y
            if(translation > 0) {
                return;
            }
            self.transform = CGAffineTransform.init(translationX: 0, y: gesture.translation(in: self.superview!).y + offset + self.bounds.size.height)
        } else {
            let translation = gesture.translation(in: self.superview!).y
            let velocity = gesture.velocity(in: self.superview!).y
            if translation > -self.bounds.size.height / 2 && velocity > -300 {
                let duration = fabs(translation) / 200.0
                UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {
                    self.transform = CGAffineTransform.init(translationX: 0, y: self.bounds.size.height)
                }) { (finished) in
                    if self.timer != nil {
                        self.timer?.fireDate = Date(timeIntervalSinceNow: kDQNotifyTimeInterval)
                    }
                }
            } else {
                let duration = fmin(0.25, self.bounds.size.height - fabs(translation) / fabs(velocity))
                UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {
                    self.transform = CGAffineTransform.identity
                }) { (finished) in
                    if self.timer != nil {
                        self.timer?.fireDate = Date.distantPast
                    }
                }
            }
        }
    }

}
