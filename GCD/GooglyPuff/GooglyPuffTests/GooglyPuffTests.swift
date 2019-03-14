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

import XCTest
@testable import GooglyPuff

private let defaultTimeoutLengthInSeconds: Int = 10 // 10 Seconds

class GooglyPuffTests: XCTestCase {
    
    func testLotsOfFacesImageURL() {
        downloadImageURL(withString: PhotoURLString.lotsOfFaces)
    }
    
    func testSuccessKidImageURL() {
        downloadImageURL(withString: PhotoURLString.successKid)
    }
    
    func testOverlyAttachedGirlfriendImageURL() {
        downloadImageURL(withString: PhotoURLString.overlyAttachedGirlfriend)
    }
    
    func downloadImageURL(withString urlString: String) {
        let url = URL(string: urlString)
        
        // 1
        let semaphore = DispatchSemaphore(value: 0)
        let _ = DownloadPhoto(url: url!) { _, error in
            if let error = error {
                XCTFail("\(urlString) failed. \(error.localizedDescription)")
            }
            
            // 2
            semaphore.signal()
        }
        let timeout = DispatchTime.now() + .seconds(defaultTimeoutLengthInSeconds)
        
        // 3
        if semaphore.wait(timeout: timeout) == .timedOut {
            XCTFail("\(urlString) timed out")
        }
    }
}
