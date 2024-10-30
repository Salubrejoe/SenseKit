
import Foundation


public class UnitAngularVelocity: Dimension {
  static let radiansPerSecond = UnitAngularVelocity(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 1.0))
  
  public func baseUnit() -> UnitAngularVelocity {
    return .radiansPerSecond
  }
  
  public static let degreesPerSecond = UnitAngularVelocity(symbol: "°/s", converter: UnitConverterLinear(coefficient: .pi / 180))
}

public class UnitMagneticField: Dimension {
  static let microteslas = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1.0))
  static let gauss = UnitMagneticField(symbol: "G", converter: UnitConverterLinear(coefficient: 100.0)) // 1 Gauss = 100 µT
  
  public func baseUnit() -> UnitMagneticField {
    return .microteslas
  }
}
