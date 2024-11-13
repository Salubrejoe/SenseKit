import Foundation

/// `UnitAngularVelocity` is a custom unit for representing angular velocity, such as rotation rate.
/// It extends `Dimension` to support conversions between radians per second and degrees per second.
///
/// - Units:
///   - `radiansPerSecond`: the base unit.
///   - `degreesPerSecond`: with a conversion coefficient.
public class UnitAngularVelocity: Dimension, @unchecked Sendable {
  
  ///
  static let radiansPerSecond = UnitAngularVelocity(
    symbol: "rad/s",
    converter: UnitConverterLinear(coefficient: 1.0)
  )
  
  /// Conversion factor: 1°/s = (pi/180) rad
  public static let degreesPerSecond = UnitAngularVelocity(
    symbol: "°/s",
    converter: UnitConverterLinear(coefficient: .pi / 180)
  )
  
  /// Specifies `radiansPerSecond` as the base unit for `UnitAngularVelocity`.
  override class public func baseUnit() -> Self {
    Self(symbol: "rad/s")
  }
}

/// `UnitMagneticField` is a custom unit for representing magnetic field strength.
/// It extends `Dimension` to support conversions between microteslas and gauss.
///
/// - Units:
///   - `microteslas`: the base unit.
///   - `gauss`: where 1 gauss equals 100 microteslas.
public class UnitMagneticField: Dimension, @unchecked Sendable {
  
  ///
  static let microteslas = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1.0))
  
  /// Conversion factor: 1 Gauss = 100 µT.
  static let gauss = UnitMagneticField(symbol: "G", converter: UnitConverterLinear(coefficient: 100.0))
  
  /// Specifies `microteslas` as the base unit for `UnitMagneticField`.
  override class public func baseUnit() -> Self {
    Self(symbol: "µT")
  }
}
