
import Foundation


public extension Measurement {
  func description(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    let usableSignificantDigits = significantDigits > 0 ? significantDigits : 0
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = usableSignificantDigits
    formatter.minimumFractionDigits = usableSignificantDigits
    
    let value = abs(self.value)
    let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value))"
    
    return includeUnit ? "\(valueString) \(self.unit.symbol)" : valueString
  }
}


public extension Measurement where UnitType == UnitLength {
  static var zeroMeters: Measurement<UnitLength> {
    .init(value: 0.0, unit: .meters)
  }
}


public extension Measurement where UnitType == UnitAngle {
  static var zeroDegrees: Measurement<UnitAngle> {
    .init(value: 0.0, unit: .degrees)
  }
  static var zeroRadians: Measurement<UnitAngle> {
    .init(value: 0.0, unit: .radians)
  }
}

public extension Measurement where UnitType == UnitSpeed {
  static var zeroMetersPerSeconds: Measurement<UnitSpeed> {
    .init(value: 0.0, unit: .metersPerSecond)
  }
}
