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

class PatternView: UIView {
  // MARK: - Structures
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
