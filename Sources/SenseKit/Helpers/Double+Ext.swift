
import Foundation


public extension Double {
  func roundTo(places: Int) -> Double {
    guard places > 0 else { return self.rounded() }
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

