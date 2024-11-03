import Foundation

public extension Measurement {
  
  /// Provides a formatted string representation of the measurement value with a specified number of significant digits.
  ///
  /// - Parameters:
  ///   - significantDigits: The number of decimal places to include. Defaults to `2`. If set to a value less than or equal to 0, it defaults to `0`.
  ///   - includeUnit: A Boolean that determines if the unit symbol should be included in the output. Defaults to `true`.
  /// - Returns: A `String` representing the measurement, formatted to the specified number of significant digits, optionally including the unit symbol.
  ///
  /// - Usage:
  ///   ```swift
  ///   let distance = Measurement(value: 123.456, unit: UnitLength.meters)
  ///   print(distance.description(significantDigits: 1)) // "123.5 m"
  ///   print(distance.description(significantDigits: 2, includeUnit: false)) // "123.46"
  ///   ```
  func description(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    let usableSignificantDigits = significantDigits > 0 ? significantDigits : 0
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = usableSignificantDigits
    formatter.minimumFractionDigits = usableSignificantDigits
    
    let value = abs(self.value)
    let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    
    return includeUnit ? "\(valueString) \(self.unit.symbol)" : valueString
  }
}

public extension Measurement where UnitType == UnitLength {
  
  /// A static `Measurement` instance representing a length of zero meters.
  static var zeroMeters: Measurement<UnitLength> {
    .init(value: 0.0, unit: .meters)
  }
}

public extension Measurement where UnitType == UnitAngle {
  
  /// A static `Measurement` instance representing an angle of zero degrees.
  static var zeroDegrees: Measurement<UnitAngle> {
    .init(value: 0.0, unit: .degrees)
  }
  
  /// A static `Measurement` instance representing an angle of zero radians.
  static var zeroRadians: Measurement<UnitAngle> {
    .init(value: 0.0, unit: .radians)
  }
}

public extension Measurement where UnitType == UnitSpeed {
  
  /// A static `Measurement` instance representing a speed of zero meters per second.
  static var zeroMetersPerSeconds: Measurement<UnitSpeed> {
    .init(value: 0.0, unit: .metersPerSecond)
  }
}
