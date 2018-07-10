# GradientDemo
彩色的进度条，学习渐变layer的使用。
使用CAGradientLayer来实现的。
CAGradientLayer是CALayer的一个特殊子类，用于生成颜色渐变的图层，使用较为方便，下面介绍下它的相关属性：

colors 渐变的颜色
locations 渐变颜色的分割点
startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变

<br>

使用：

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

extension ViewController: ColorsViewDelegate {

func currentPresent(value: CGFloat) {
self.presentLabel.text = String(format: "%.2f%", (100 - value))
}
}

效果截图：
<br>
[Alt Img](https://github.com/weiman152/GradientDemo/blob/master/screenShots/QQ20180710-162127.gif)
<br><br>

[Alt Img](https://github.com/weiman152/GradientDemo/blob/master/screenShots/1111.png)



