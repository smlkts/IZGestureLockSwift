//
//  IZGestureLock.swift
//  IZGestureLockSwift
//
//  Created by 张雁军 on 22/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

import UIKit

class IZGestureLock: UIControl {

    var lineColor = UIColor.red
    var highlightedLineColor: UIColor?
    
    var lineWidth = 6.0
    var itemSize = CGSize.init(width: 40, height: 40)
    var contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    private let points: [UIButton] = {
        var temp = [UIButton].init()
        for i in 0..<9 {
            var btn = UIButton(type: .custom)
            btn.tag = i + 1
            btn.isUserInteractionEnabled = false
            btn.isSelected = false
            temp.append(btn)
        }
        return temp
    }()
    
    private var throughPoints = [UIButton].init()
    private var fingerPoint: NSValue?
    private let drawingLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 6
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        return layer
    }()
    
    var didFinishDrawing: ((_ lock: IZGestureLock, _ password: String) -> Void)? = nil
    
    func setNormalImage(image: UIImage) {
        for btn: UIButton in points{
            btn.setImage(image, for: .normal)
        }
    }
    
    func setSelectedImage(image: UIImage) {
        for btn: UIButton in points{
            btn.setImage(image, for: .selected)
        }
    }
    
    func setHighlightedImage(image: UIImage) {
        for btn: UIButton in points{
            btn.setImage(image, for: .highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(drawingLayer)
        for btn: UIButton in points {
            addSubview(btn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = (bounds.size.width - contentInset.left - itemSize.width / 2 - itemSize.width / 2 - contentInset.right) / 2
        let h: CGFloat = (bounds.size.height - contentInset.top - itemSize.height / 2 - itemSize.height / 2 - contentInset.bottom) / 2
        for (idx, obj) in points.enumerated(){
            let row: Int = idx / 3
            let col: Int = idx % 3
            obj.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(itemSize.width), height: CGFloat(itemSize.height))
            obj.center = CGPoint(x: CGFloat(contentInset.left + itemSize.width / 2 + w * CGFloat(col)), y: CGFloat(contentInset.top + itemSize.height / 2 + h * CGFloat(row)))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIControl
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        clean()
        var shouldBegin: Bool = false
        for obj in points{
            if obj.frame.contains(touch.location(in: self)) {
                shouldBegin = true
                throughPoints.append(obj)
                obj.isSelected = true
                layer.insertSublayer(obj.layer, above: drawingLayer)
                self.draw()
                break
            }
        }
        return shouldBegin
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        fingerPoint = NSValue(cgPoint: touch.location(in: self))
        for obj in points{
            if obj.frame.contains(touch.location(in: self)) {
                if !throughPoints.contains(obj) {
                    throughPoints.append(obj)
                    obj.isSelected = true
                    layer.insertSublayer(obj.layer, above: drawingLayer)
                }
            }
        }
        draw()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        fingerPoint = nil
        draw()
        if (didFinishDrawing != nil) {
            let tags: [Int]? = (throughPoints as NSArray).value(forKeyPath: "tag") as? [Int]
            var pwd = String()
            for obj in tags! {
                pwd.append(String(obj))
            }
            didFinishDrawing!(self, pwd)
        }
    }
    
    func draw() {
        if throughPoints.count > 0{
            let path = UIBezierPath()
            let p0: CGPoint = throughPoints.first!.center
            path.move(to: p0)
            for (idx, obj) in throughPoints.enumerated(){
                if idx != 0 {
                    path.addLine(to: obj.center)
                }
            }
            if fingerPoint != nil {
                path.addLine(to: (fingerPoint?.cgPointValue)!)
            }
            drawingLayer.path = path.cgPath
        }
        else {
            drawingLayer.path = nil
        }
    }
    
    // MARK: -
    func clean() {
        for obj in points{
            layer.insertSublayer(obj.layer, below: drawingLayer)
            obj.isHighlighted = false
            obj.isSelected = false
        }
        drawingLayer.strokeColor = lineColor.cgColor
        drawingLayer.path = nil
        throughPoints.removeAll()
    }
    
    func clean(afterDuration duration: TimeInterval, completion : (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if !self.isTracking || !self.isTouchInside {
                self.clean()
            }
            if completion != nil {
                completion!()
            }
        }
    }
    
    func highlight(withDuration duration: TimeInterval, completion: (() -> Void)?) {
        drawingLayer.strokeColor = highlightedLineColor?.cgColor
        for obj in throughPoints {
            obj.isSelected = false
            obj.isHighlighted = true
        }
        draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if !self.isTracking || !self.isTouchInside {
                self.clean()
            }
            if completion != nil {
                completion!()
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
