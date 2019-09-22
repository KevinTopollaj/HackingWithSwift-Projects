import UIKit
import Foundation

//-------------------------------------------------------------------------------------
/// Challenge 1
//-------------------------------------------------------------------------------------
// 1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView {
  func bounceOut(duration: TimeInterval) {
    UIView.animate(withDuration: duration) { [unowned self] in
      self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    }
  }
}

let view = UIView()
view.bounceOut(duration: 5)

//-------------------------------------------------------------------------------------
/// Challenge 2
//-------------------------------------------------------------------------------------
// 2. Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
extension Int {
  func times(_ closure: () -> Void) {
    // the number should be biger than 0
    guard self > 0 else { return }
    // iterate from 0 to the specified number not including it and run the closure
    for _ in 0..<self {
      closure()
    }
  }
}

5.times { print("Hi") }

//-------------------------------------------------------------------------------------
/// Challenge 3
//-------------------------------------------------------------------------------------
// 3. Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!
extension Array where Element: Comparable {
  mutating func remove(item: Element) {
    if let location = self.firstIndex(of: item) {
      self.remove(at: location)
    }
  }
}

var numbers = [1, 3, 3, 4, 5]
numbers.remove(item: 3)
