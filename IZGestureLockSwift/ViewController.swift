//
//  ViewController.swift
//  IZGestureLockSwift
//
//  Created by 张雁军 on 22/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

import UIKit

enum GestureLockType : Int {
    case create
    case confirm
}

class ViewController: UIViewController {
    var lockType = GestureLockType.create
    var pwd: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fps = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(245), height: CGFloat(30)))
        fps.center = CGPoint(x: CGFloat(view.bounds.size.width / 2), y: CGFloat(120))
        fps.textAlignment = .center
        fps.backgroundColor = UIColor.red
        fps.textColor = UIColor.white
        fps.layer.cornerRadius = 15
        fps.layer.masksToBounds = true
        fps.text = "请至少选择4个连接点"
        view.addSubview(fps)
        
        
        let gesturelock = IZGestureLock()
        gesturelock.lineWidth = 2
        gesturelock.lineColor = UIColor.green
        gesturelock.highlightedLineColor = UIColor.red
        gesturelock.contentInset = UIEdgeInsetsMake(15, 15, 15, 15)
        gesturelock.itemSize = CGSize(width: CGFloat(65), height: CGFloat(65))
        gesturelock.setNormalImage(image: UIImage.init(named: "p_nl")!)
        gesturelock.setSelectedImage(image: UIImage(named: "p_sl")!)
        gesturelock.setHighlightedImage(image: UIImage(named: "p_hl")!)
        gesturelock.didFinishDrawing = {(_ lock: IZGestureLock, _ password: String) -> Void in
            if self.lockType == .create {
                if password.characters.count < 4 {
                    fps.text = "请至少选择4个连接点"
                    self.shake(fps)
                    lock.highlight(withDuration: 0.8, completion: nil)
                }
                else {
                    self.lockType = .confirm
                    fps.text = "请再次绘制上一次的图案"
                    self.pwd = password
                    lock.clean()
                }
            }
            else {
                if (self.pwd == password) {
                    fps.text = "成功"
                    lock.clean(afterDuration: 0.8, completion: {() -> Void in
                        //                        navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    fps.text = "跟上次不一样 重新来"
                    self.shake(fps)
                    lock.highlight(withDuration: 0.8, completion: nil)
                }
            }
        }
        view.addSubview(gesturelock)
        gesturelock.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: gesturelock, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: gesturelock, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[gesturelock(295)]", options: [], metrics: nil, views: ["gesturelock": gesturelock]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[gesturelock(295)]", options: [], metrics: nil, views: ["gesturelock": gesturelock]))
        
        
    }
    
    func shake(_ view: UIView) {
        let from = CGPoint(x: CGFloat(view.layer.position.x), y: CGFloat(view.layer.position.y))
        let to = CGPoint(x: CGFloat(view.layer.position.x + 8), y: CGFloat(view.layer.position.y))
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = NSValue.init(cgPoint: from)
        animation.toValue = NSValue(cgPoint: to)
        animation.autoreverses = true
        animation.duration = 0.09
        animation.repeatCount = 2
        view.layer.add(animation, forKey: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

