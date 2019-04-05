/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit


let kIsColored = false

enum PatternDirection: CaseIterable {
  case left
  case top
  case right
  case bottom
}

class PatternView: UIView {
  
  public struct Constants {
    static let patternSize: CGFloat = 30.0
    static let patternRepeatCount = 2
    
  }
  
  // MARK: - Constants
  enum PatternDirection: String, CaseIterable {
    case left = "L"
    case top = "T"
    case right = "R"
    case bottom = "B"
  }
  
  override func draw(_ rect: CGRect) {
    // 1
    let context = UIGraphicsGetCurrentContext()!
    // 2
    UIColor.white.setFill()
    // 3
    context.fill(rect)
    // 我们为 drawPattern 提供回调，releaseInfo 接受系统释放模式时调用的回调。如果在模式中使用私有数据，通常会设置一个 release 回调函数。由于我们不在 draw 方法中使用私有数据，因此将 nil 传递给此回调。
    var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawTriangle, releaseInfo: nil)
    
    // 创建一个模式对象
    
    /// 参数：
    /*
     info：指向要在模式回调中使用的任何私有数据的指针。由于没有使用任何私有数据，所以传递的是 nil；
     bounds：模式 cell 的边界框。
     matrix：表示要应用的变换的矩阵。我们传递了 identity 矩阵，因为您没有应用任何变换；
     xStep：模式单元格之间的水平间距。
     yStep：模式单元格之间的垂直间距。
     tiling：更改为用户空间单位和设备像素之间的差异。
     isColored：模式单元格绘制方法是否应用颜色。true，设置颜色 false:蒙版模式
     callbacks：指向保存模式回调的结构的指针。
     */
    // 1
    let patternStepX: CGFloat = rect.width / CGFloat(Constants.patternRepeatCount)
    let patternStepY: CGFloat = rect.height / CGFloat(Constants.patternRepeatCount)
    // 2
    let patternOffsetX: CGFloat = (patternStepX - Constants.patternSize) / 2.0
    let patternOffsetY: CGFloat = (patternStepY - Constants.patternSize) / 2.0
    // 3
    var transform: CGAffineTransform
    // 2
    switch direction {
    case .top:
      transform = .identity
    case .right:
      transform = CGAffineTransform(rotationAngle: CGFloat(0.5 * .pi))
    case .bottom:
      transform = CGAffineTransform(rotationAngle: CGFloat(1.0 * .pi))
    case .left:
      transform = CGAffineTransform(rotationAngle: CGFloat(1.5 * .pi))
    }
    // 3
    transform = transform.translatedBy(x: patternOffsetX, y: patternOffsetY)
    // 4
    let pattern = CGPattern(info: nil,
                            bounds: CGRect(x: 0,
                                           y: 0,
                                           width: Constants.patternSize,
                                           height: Constants.patternSize),
                            matrix: transform,
                            xStep: patternStepX,
                            yStep: patternStepY,
                            tiling: .constantSpacing,
                            isColored: kIsColored,
                            callbacks: &callbacks)
    if kIsColored {
      // 创建模式颜色空间。对于彩色模式，基本空间参数应为 nil。这会将着色委托给模式单元格绘制方法。
      let patternSpace = CGColorSpace(patternBaseSpace: nil)!
      // 将填充颜色空间设置为定义的模式颜色空间。
      context.setFillColorSpace(patternSpace)
      /// 填充模式
      var alpha : CGFloat = 1.0
      context.setFillPattern(pattern!, colorComponents: &alpha)
    } else {
      let baseSpace = CGColorSpaceCreateDeviceRGB()
      let patternSpace = CGColorSpace(patternBaseSpace: baseSpace)!
      context.setFillColorSpace(patternSpace)
      
      context.setFillPattern(pattern!, colorComponents: fillColor)
    }
    
    context.fill(rect)
  }
  
  let drawTriangle: CGPatternDrawPatternCallback = { _, context in
    let trianglePath = UIBezierPath(triangleIn: CGRect(x: 0, y: 0, width: Constants.patternSize, height: Constants.patternSize))
    context.addPath(trianglePath.cgPath)
    context.fillPath()
  }
  
  /// RGBA
  var fillColor: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
  var direction: PatternDirection = .top
  
  init(fillColor: [CGFloat], direction: PatternDirection = .top) {
    self.fillColor = fillColor
    self.direction = direction
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension UIBezierPath {
  // 1
  convenience init(triangleIn rect: CGRect) {
    self.init()
    // 2
    let topOfTriangle = CGPoint(x: rect.width / 2, y: 0)
    let bottomLeftOfTriangle = CGPoint(x: 0, y: rect.height)
    let bottomRightOfTriangle = CGPoint(x: rect.width, y: rect.height)
    // 3
    self.move(to: topOfTriangle)
    self.addLine(to: bottomLeftOfTriangle)
    self.addLine(to: bottomRightOfTriangle)
    // 4
    self.close()
  }
}
/*
class PatternView: UIView {
  // MARK: - Structures
  public struct Constants {
    static let patternSize: CGFloat = 30.0
    static let patternRepeatCount = 2
  }
  
  
  
  // MARK: - Properties
  var fillColor: [CGFloat] = [1.0, 0.0, 0.0, 1.0] {
    didSet {
      directionLabel.backgroundColor =
        UIColor(red: fillColor[0], green: fillColor[1], blue: fillColor[2], alpha: fillColor[3])
    }
  }
  
  var direction: PatternDirection = .top {
    didSet {
      directionLabel.text = direction.rawValue
    }
  }
  
  lazy var directionLabel: UILabel = {
    let directionLabel =
      UILabel(frame: CGRect(x: 2, y: 2, width: Constants.patternSize, height: Constants.patternSize))
    directionLabel.text = direction.rawValue
    directionLabel.textColor = .white
    return directionLabel
  }()

  // MARK: - Initialization
  init(fillColor: [CGFloat], direction: PatternDirection = .top) {
    self.fillColor = fillColor
    self.direction = direction
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    addSubview(directionLabel)
  }
}
*/
