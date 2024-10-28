
import Foundation


public class UnitAngularVelocity: Dimension {
  static let radiansPerSecond = UnitAngularVelocity(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 1.0))
  
  func baseUnit() -> UnitAngularVelocity {
    return .radiansPerSecond
  }
}

public class UnitMagneticField: Dimension {
  static let microteslas = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1.0))
  static let gauss = UnitMagneticField(symbol: "G", converter: UnitConverterLinear(coefficient: 100.0)) // 1 Gauss = 100 µT
  
  func baseUnit() -> UnitMagneticField {
    return .microteslas
  }
}
