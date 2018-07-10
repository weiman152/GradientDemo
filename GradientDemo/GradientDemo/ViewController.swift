//
//  ViewController.swift
//  GradientDemo
//
//  Created by iOS on 2018/6/19.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorView: ColorsView!
    @IBOutlet weak var presentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    private func setup() {
        
        let colors = ["3DF6C4", "FBE816", "FBBA21", "EB8244", "FB164B"]
        let locations: [NSNumber] = [0.2, 0.3, 0.7, 0.75, 1.0]
        colorView.set(colors: colors, locations: locations, landscape: false)
        colorView.delegate = self
        colorView.set(radius: 6)
    }
    
}

extension ViewController {
    
    /// 开始
    @IBAction func click(_ sender: UIButton) {
        
        colorView.set(duration: 60)
    }
    
    /// 停止
    @IBAction func stopAction(_ sender: Any) {
        colorView.stop()
    }
    
}

extension ViewController {
    
    private func showPresent() {
        
    }
}

extension ViewController: ColorsViewDelegate {
    
    func currentPresent(value: CGFloat) {
        self.presentLabel.text = String(format: "%.2f%", (100 - value))
    }
}






















