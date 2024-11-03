import Foundation

/// `UnitAngularVelocity` is a custom unit for representing angular velocity, such as rotation rate, in specific units.
/// It extends `Dimension` to support conversions between radians per second and degrees per second.
///
/// - Units:
///   - `radiansPerSecond`: Angular velocity in radians per second, the base unit.
///   - `degreesPerSecond`: Angular velocity in degrees per second, with a conversion coefficient.
public class UnitAngularVelocity: Dimension {
  
  /// Angular velocity in radians per second, serving as the base unit for `UnitAngularVelocity`.
  static let radiansPerSecond = UnitAngularVelocity(
    symbol: "rad/s",
    converter: UnitConverterLinear(coefficient: 1.0)
  )
  
  /// Angular velocity in degrees per second.
  public static let degreesPerSecond = UnitAngularVelocity(
    symbol: "°/s",
    converter: UnitConverterLinear(coefficient: .pi / 180)
  )
  
  /// Specifies `radiansPerSecond` as the base unit for `UnitAngularVelocity`.
  override class public func baseUnit() -> Self {
    Self(symbol: "rad/s")
  }
}

/// `UnitMagneticField` is a custom unit for representing magnetic field strength in specific units.
/// It extends `Dimension` to support conversions between microteslas and gauss.
///
/// - Units:
///   - `microteslas`: Magnetic field strength in microteslas, the base unit.
///   - `gauss`: Magnetic field strength in gauss, where 1 gauss equals 100 microteslas.
public class UnitMagneticField: Dimension {
  
  /// Magnetic field strength in microteslas, serving as the base unit for `UnitMagneticField`.
  static let microteslas = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1.0))
  
  /// Magnetic field strength in gauss. Conversion factor: 1 Gauss = 100 µT.
  static let gauss = UnitMagneticField(symbol: "G", converter: UnitConverterLinear(coefficient: 100.0))
  
  /// Specifies `microteslas` as the base unit for `UnitMagneticField`.
  override class public func baseUnit() -> Self {
    Self(symbol: "µT")
  }
}
