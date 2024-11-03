
import Foundation


public extension Double {
  
  /// Rounds the `Double` to a specified number of decimal places.
  ///
  /// - Parameter places: The number of decimal places to round to. If `places` is 0 or less, it rounds to the nearest whole number.
  /// - Returns: A `Double` rounded to the specified number of decimal places.
  ///
  /// - Usage:
  ///   ```swift
  ///   let value = 3.14159
  ///   let roundedValue = value.roundTo(places: 2) // 3.14
  ///   ```
  func roundTo(places: Int) -> Double {
    guard places > 0 else { return self.rounded() }
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

