# IZGestureLockSwift
九宫格手势解锁Swift版

[简书链接](http://www.jianshu.com/p/e829c09a0bba)

 ![](https://github.com/smlkts/IZGestureLockSwift/raw/master/0.gif) 
 ![](https://github.com/smlkts/IZGestureLockSwift/raw/master/1.gif)

## Usage:

```
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
```