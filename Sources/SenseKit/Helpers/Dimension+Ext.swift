
import Foundation


public class UnitAngularVelocity: Dimension {
  static let radiansPerSecond = UnitAngularVelocity(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 1.0))
  
  override class public func baseUnit() -> Self {
    Self(symbol: "rad/s")
  }
  
  public static let degreesPerSecond = UnitAngularVelocity(symbol: "°/s", converter: UnitConverterLinear(coefficient: .pi / 180))
}

public class UnitMagneticField: Dimension {
  static let microteslas = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1.0))
  static let gauss = UnitMagneticField(symbol: "G", converter: UnitConverterLinear(coefficient: 100.0)) // 1 Gauss = 100 µT
  
  override class public func baseUnit() -> Self {
    Self(symbol: "µT")
  }
}