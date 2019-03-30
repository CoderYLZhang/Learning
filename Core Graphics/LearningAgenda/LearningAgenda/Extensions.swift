/// Copyright (c) 2019 Razeware LLC
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

extension UIColor {
  static let rwShadow = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
  static let rwLightGray = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
  static let rwDarkGray = UIColor(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1)
  static let rwLightBlue = UIColor(red: 105/255.0, green: 179/255.0, blue: 216/255.0, alpha: 1)
  static let rwDarkBlue = UIColor(red: 21/255.0, green: 92/255.0, blue: 136/255.0, alpha: 1)
  static let rwLightPurple = UIColor(red: 147/255.0, green: 105/255.0, blue: 216/255.0, alpha: 1)
  static let rwDarkPurple = UIColor(red: 72/255.0, green: 22/255.0, blue: 137/255.0, alpha: 1)
}

extension CGRect {
  func rectFor1PxStroke() -> CGRect {
    return CGRect(x: origin.x + 0.5, y: origin.y + 0.5, width: size.width - 1, height: size.height - 1)
  }
}

extension CGContext {
  func drawLinearGradient(rect: CGRect, startColor: UIColor, endColor: UIColor) {
    let gradient = CGGradient(colorsSpace: nil, colors: [startColor.cgColor, endColor.cgColor] as CFArray, locations: [0, 1])!
    
    let startPoint = CGPoint(x: rect.midX, y: rect.minY)
    let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
    saveGState()
    addRect(rect)
    clip()
    drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])    
    restoreGState()
  }
  
  func drawGlossAndGradient(rect: CGRect, startColor: UIColor, endColor: UIColor) {
    drawLinearGradient(rect: rect, startColor: startColor, endColor: endColor)
    
    let glossColor1 = UIColor.white.withAlphaComponent(0.35)
    let glossColor2 = UIColor.white.withAlphaComponent(0.1)
    
    var topHalf = rect
    topHalf.size.height /= 2
    
    drawLinearGradient(rect: topHalf, startColor: glossColor1, endColor: glossColor2)
  }
}

