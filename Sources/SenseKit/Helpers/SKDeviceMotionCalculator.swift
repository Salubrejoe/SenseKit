import CoreMotion

/// `SKDeviceMotionCalculator` is a utility class for processing motion data from a `CMDeviceMotion` instance.
/// This class calculates various properties like attitude, rotation rate, gravity, user acceleration, and heading,
/// returning the data as vectors with specific units.
///
/// - Singleton: Access the shared instance via `SKDeviceMotionCalculator.shared`.
/// - Core Motion Data: Utilizes `CMDeviceMotion` data for calculations.
/// - Units: Returns values in `Measurement` with appropriate units for straightforward conversions.

public class SKDeviceMotionCalculator {
  
  /// Shared singleton instance of `DeviceMotionCalculator`.
  static public let shared = SKDeviceMotionCalculator()
  
  /// Calculates the device’s attitude (pitch, roll, and yaw) in radians.
  ///
  /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
  /// - Returns: A `Vector<UnitAngle>` containing pitch, roll, and yaw as `Measurement<UnitAngle>` values.
  public func calculateAttitude(from motionData: CMDeviceMotion) -> SKVector<UnitAngle> {
    let attitude = motionData.attitude
    let pitch = Measurement<UnitAngle>(value: attitude.pitch, unit: .radians)
    let roll  = Measurement<UnitAngle>(value: attitude.roll, unit: .radians)
    let yaw   = Measurement<UnitAngle>(value: attitude.yaw, unit: .radians)
    return SKVector(x: pitch, y: roll, z: yaw)
  }
  
  /// Calculates the device’s rotation rate around each axis, measured in radians per second.
  ///
  /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
  /// - Returns: A `Vector<UnitAngularVelocity>` with `x`, `y`, and `z` as `Measurement<UnitAngularVelocity>` values in radians per second.
  public func calculateRotationRate(from motionData: CMDeviceMotion) -> SKVector<UnitAngularVelocity> {
    let rotationRate  = motionData.rotationRate
    let rotationRateX = Measurement<UnitAngularVelocity>(value: rotationRate.x, unit: .radiansPerSecond)
    let rotationRateY = Measurement<UnitAngularVelocity>(value: rotationRate.y, unit: .radiansPerSecond)
    let rotationRateZ = Measurement<UnitAngularVelocity>(value: rotationRate.z, unit: .radiansPerSecond)
    return SKVector(x: rotationRateX, y: rotationRateY, z: rotationRateZ)
  }
  
  /// Calculates the gravity vector acting on the device, measured in `g` (gravitational acceleration).
  ///
  /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
  /// - Returns: A `Vector<UnitAcceleration>` with `x`, `y`, and `z` components as `Measurement<UnitAcceleration>` values in units of gravity.
  public func calculateGravity(from motionData: CMDeviceMotion) -> SKVector<UnitAcceleration> {
    let gravity  = motionData.gravity
    let gravityX = Measurement<UnitAcceleration>(value: gravity.x, unit: .gravity)
    let gravityY = Measurement<UnitAcceleration>(value: gravity.y, unit: .gravity)
    let gravityZ = Measurement<UnitAcceleration>(value: gravity.z, unit: .gravity)
    return SKVector(x: gravityX, y: gravityY, z: gravityZ)
  }
  
  /// Calculates the acceleration of the user independent of gravity, measured in `g`.
  ///
  /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
  /// - Returns: A `Vector<UnitAcceleration>` with `x`, `y`, and `z` components as `Measurement<UnitAcceleration>` values in units of gravity.
  public func calculateUserAcceleration(from motionData: CMDeviceMotion) -> SKVector<UnitAcceleration> {
    let userAcceleration = motionData.userAcceleration
    let userAccelerationX = Measurement<UnitAcceleration>(value: userAcceleration.x, unit: .gravity)
    let userAccelerationY = Measurement<UnitAcceleration>(value: userAcceleration.y, unit: .gravity)
    let userAccelerationZ = Measurement<UnitAcceleration>(value: userAcceleration.z, unit: .gravity)
    return SKVector(x: userAccelerationX, y: userAccelerationY, z: userAccelerationZ)
  }
  
  /// Calculates the device’s heading in degrees.
  ///
  /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
  /// - Returns: A `Measurement<UnitAngle>` representing the device heading in degrees, rounded to two decimal places.
  public func calculateHeading(from motionData: CMDeviceMotion) -> Measurement<UnitAngle> {
    Measurement<UnitAngle>(value: motionData.heading.roundTo(places: 2), unit: .degrees)
  }
  
  /*
   /// Calculates the magnetic field around the device in microteslas.
   ///
   /// - Parameter motionData: A `CMDeviceMotion` instance containing the device's current motion data.
   /// - Returns: A `Vector<UnitMagneticField>` with `x`, `y`, and `z` components as `Measurement<UnitMagneticField>` values in microteslas.
   public func calculateMagneticField(from motionData: CMDeviceMotion) -> Vector<UnitMagneticField> {
   let field = motionData.magneticField.field
   let x = Measurement<UnitMagneticField>(value: field.x, unit: .microteslas)
   let y = Measurement<UnitMagneticField>(value: field.y, unit: .microteslas)
   let z = Measurement<UnitMagneticField>(value: field.z, unit: .microteslas)
   return Vector(x: x, y: y, z: z)
   }
   */
}
