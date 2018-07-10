//
//  ColorsView.swift
//  GradientDemo
//
//  Created by iOS on 2018/6/20.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

/// 彩色渐变的View
/*
 实现说明
 //CAGradientLayer实现渐变
 
 CAGradientLayer是CALayer的一个特殊子类，用于生成颜色渐变的图层，使用较为方便，下面介绍下它的相关属性：
 
 colors 渐变的颜色
 locations 渐变颜色的分割点
 startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
 
 */
protocol ColorsViewDelegate: NSObjectProtocol {
    /// 当前进度
    func currentPresent(value: CGFloat)
}

class ColorsView: UIView {
    
    weak var delegate: ColorsViewDelegate?
    
    private var gradientLayer = CAGradientLayer()
    /// 如果是彩色进度的话，需要设置进度的辅助view
    private lazy var grayView: UIView = {
        $0.backgroundColor = UIColor.hex("EEEEEE", alpha: 1.0)
        return $0
    }( UIView() )
    private var currentTime: Float = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupLayout()
    }
    
    private func setup() {
        layer.addSublayer(gradientLayer)
        addSubview(grayView)
    }
    
    private func setupLayout() {
        gradientLayer.frame = bounds
        grayView.frame = CGRect(x: -1, y: -1, width: bounds.width+2, height: 0)
    }
    
}

/// 公有方法
extension ColorsView {
    
    /// 设置渐变色
    ///
    /// - Parameters:
    ///   - colors: 颜色色值的集合，如["00FF00", "FF0000"]
    ///   - locations: 每个颜色值所占的位置
    ///   - landscape: 是否是横向
    func set(colors: [String],
             locations: [NSNumber],
             landscape: Bool)
    {
        // 取出颜色
        var colorArray: [Any] = []
        for color in colors {
            colorArray.append(UIColor.hex(color).cgColor)
        }
        
        gradientLayer.colors = colorArray
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        if landscape {
            // 横向
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        } else {
            // 竖向
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
    }
    
    func set(radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func set(colorY: CGFloat) {
        grayView.frame = CGRect(x: -1, y: -1, width: bounds.width + 2, height: colorY)
    }
    
    /// 设置经过duration时间，整个彩色条匀速走完
    func set(duration: TimeInterval) {
        currentTime = Float(duration * 100)
        let origialHeigth = bounds.height
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { [weak self] in
            self?.grayView.frame.size.height = origialHeigth + 2
            self?.updatePresent()
        }) { [weak self] (success) in
            if success == true {
                self?.grayView.frame.size.height = origialHeigth + 2
            } else {
                
            }
        }
        
        perform(#selector(pastOneSecond),
                with: nil,
                afterDelay: 0.01)
    }
    
    /// 结束动画
    func stop() {
        grayView.layer.removeAllAnimations()
        let newFrame = getCurrentFrame()
        grayView.frame = newFrame
        currentTime = -1
    }
    
}

/// 私有方法
extension ColorsView {
    
    @objc func pastOneSecond() {
        
        currentTime -= 1
        if currentTime > 0 {
            set(duration: TimeInterval(currentTime))
        } else {
            if currentTime == 0 {
                
            }
            print("执行结束")
        }
        
    }
    
    private func updatePresent() {
        
        let present = getPresent()
        DispatchQueue.main.async {
            self.delegate?.currentPresent(value: present)
        }
    }
    
    /// 获取当前的进度
    private func getPresent() -> CGFloat {
        
        let origialH = frame.size.height
        
        if let temp = grayView.layer.presentation() {
            let rect: CGRect = temp.frame
            
            let present = rect.size.height / origialH * 100
            return present
        } else {
            return 100
        }
        
    }
    
    private func getCurrentFrame() -> CGRect {
        
        if let temp = grayView.layer.presentation() {
            let rect: CGRect = temp.frame
            return rect
        } else {
            return grayView.frame
        }
    }
    
}

extension UIColor {
    
    static func hex(_ string: String, alpha: CGFloat = 1) -> UIColor {
        let scanner = Scanner(string: string)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        if #available(iOS 10.0, *) {
            return UIColor(
                displayP3Red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
        } else {
            return UIColor(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: alpha
            )
        }
    }
    
}





