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
    
    let value = self.value
    let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    
    return includeUnit ? "\(valueString) \(self.unit.symbol)" : valueString
  }
}




// MARK: - Zeros

public extension Measurement where UnitType == UnitLength {
  
  /// A static `Measurement` instance representing a length of zero meters.
  static var zeroMeters: Measurement<UnitLength> {
    .init(value: 0.0, unit: .meters)
  }
  
  /// A static `Measurement` instance representing a length of zero miles.
  static var zeroMiles: Measurement<UnitLength> {
    .init(value: 0.0, unit: .miles)
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
  static var zeroMetersPerSecond: Measurement<UnitSpeed> {
    .init(value: 0.0, unit: .metersPerSecond)
  }
  
  /// A static `Measurement` instance representing a speed of zero miles per hour.
  static var zeroMilesPerHour: Measurement<UnitSpeed> {
    .init(value: 0.0, unit: .milesPerHour)
  }
}

public extension Measurement where UnitType == UnitAcceleration {
  
  /// A static `Measurement` instance representing an acceleration of zero meters per second squared.
  static var zeroMetersPerSecondSquared: Measurement<UnitAcceleration> {
    .init(value: 0.0, unit: .metersPerSecondSquared)
  }
  
  /// A static `Measurement` instance representing an acceleration of zero Gs.
  static var zeroGs: Measurement<UnitAcceleration> {
    .init(value: 0.0, unit: .gravity)
  }
}

public extension Measurement where UnitType == UnitAngularVelocity {
  
  /// A static `Measurement` instance representing an angular velocity of zero radians per second.
  static var zeroRadiansPerSecond: Measurement<UnitAngularVelocity> {
    .init(value: 0.0, unit: .radiansPerSecond)
  }
  
  /// A static `Measurement` instance representing an angular velocity of zero degrees per second.
  static var zeroDegreesPerSecond: Measurement<UnitAngularVelocity> {
    .init(value: 0.0, unit: .degreesPerSecond)
  }
}

public extension Measurement where UnitType == UnitMagneticField {
  
  /// A static `Measurement` instance representing a magnetic field strength of zero microteslas.
  static var zeroMicroteslas: Measurement<UnitMagneticField> {
    .init(value: 0.0, unit: .microteslas)
  }
  
  /// A static `Measurement` instance representing a magnetic field strength of zero gauss.
  static var zeroGauss: Measurement<UnitMagneticField> {
    .init(value: 0.0, unit: .gauss)
  }
}
