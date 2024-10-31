
import CoreMotion



public class DeviceMotionCalculator {
  static public let shared = DeviceMotionCalculator()
  
  public func calculateAttitude(from motionData: CMDeviceMotion) -> Vector<UnitAngle> {
    let attitude = motionData.attitude
    let pitch = Measurement<UnitAngle>(value: attitude.pitch.roundTo(places: 3), unit: .radians)
    let roll  = Measurement<UnitAngle>(value: attitude.roll.roundTo(places: 3), unit: .radians)
    let yaw   = Measurement<UnitAngle>(value: attitude.yaw.roundTo(places: 3), unit: .radians)
    return Vector(x: pitch, y: roll, z: yaw)
  }
  
  public func calculateRotationRate(from motionData: CMDeviceMotion) -> Vector<UnitAngularVelocity> {
    let rotationRate  = motionData.rotationRate
    let rotationRateX = Measurement<UnitAngularVelocity>(value: rotationRate.x.roundTo(places: 2), unit: .radiansPerSecond)
    let rotationRateY = Measurement<UnitAngularVelocity>(value: rotationRate.y.roundTo(places: 2), unit: .radiansPerSecond)
    let rotationRateZ = Measurement<UnitAngularVelocity>(value: rotationRate.z.roundTo(places: 2), unit: .radiansPerSecond)
    return Vector(x: rotationRateX, y: rotationRateY, z: rotationRateZ)
  }
  
  public func calculateGravity(from motionData: CMDeviceMotion) -> Vector<UnitAcceleration> {
    let gravity  = motionData.gravity
    let gravityX = Measurement<UnitAcceleration>(value: gravity.x.roundTo(places: 1), unit: .gravity)
    let gravityY = Measurement<UnitAcceleration>(value: gravity.y.roundTo(places: 1), unit: .gravity)
    let gravityZ = Measurement<UnitAcceleration>(value: gravity.z.roundTo(places: 1), unit: .gravity)
    return Vector(x: gravityX, y: gravityY, z: gravityZ)
  }
  
  public func calculateUserAcceleration(from motionData: CMDeviceMotion) -> Vector<UnitAcceleration> {
    let userAcceleration = motionData.userAcceleration
    let userAccelerationX = Measurement<UnitAcceleration>(value: userAcceleration.x.roundTo(places: 1), unit: .gravity)
    let userAccelerationY = Measurement<UnitAcceleration>(value: userAcceleration.y.roundTo(places: 1), unit: .gravity)
    let userAccelerationZ = Measurement<UnitAcceleration>(value: userAcceleration.z.roundTo(places: 1), unit: .gravity)
    return Vector(x: userAccelerationX, y: userAccelerationY, z: userAccelerationZ)
  }
//  
//  public func calculateHeading(from motionData: CMDeviceMotion) -> Measurement<UnitAngle> {
//    Measurement<UnitAngle>(value: motionData.heading.roundTo(places: 2), unit: .degrees)
//  }
  
  public func calculateMagneticFIeld(from motionData: CMDeviceMotion) -> Vector<UnitMagneticField> {
    let field = motionData.magneticField.field
    let x = Measurement<UnitMagneticField>(value: field.x, unit: .microteslas)
    let y = Measurement<UnitMagneticField>(value: field.y, unit: .microteslas)
    let z = Measurement<UnitMagneticField>(value: field.z, unit: .microteslas)
    return Vector(x: x, y: y, z: z)
  }
}


public extension Double {
  func roundTo(places: Int) -> Double {
    guard places > 0 else { return self.rounded() }
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
