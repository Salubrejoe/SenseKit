
import CoreMotion



public class DeviceMotionCalculator {
  static public let shared = DeviceMotionCalculator()
  
  public func calculateAttitude(from motionData: CMDeviceMotion) -> Vector<UnitAngle> {
    let pitch = Measurement<UnitAngle>(value: motionData.attitude.pitch, unit: .radians)
    let roll = Measurement<UnitAngle>(value: motionData.attitude.roll, unit: .radians)
    let yaw = Measurement<UnitAngle>(value: motionData.attitude.yaw, unit: .radians)
    return Vector(x: pitch, y: roll, z: yaw)
  }
  
  public func calculateRotationRate(from motionData: CMDeviceMotion) -> Vector<UnitAngularVelocity> {
    let rotationRateX = Measurement<UnitAngularVelocity>(value: motionData.rotationRate.x, unit: .radiansPerSecond)
    let rotationRateY = Measurement<UnitAngularVelocity>(value: motionData.rotationRate.y, unit: .radiansPerSecond)
    let rotationRateZ = Measurement<UnitAngularVelocity>(value: motionData.rotationRate.z, unit: .radiansPerSecond)
    return Vector(x: rotationRateX, y: rotationRateY, z: rotationRateZ)
  }
  
  public func calculateGravity(from motionData: CMDeviceMotion) -> Vector<UnitAcceleration> {
    let gravityX = Measurement<UnitAcceleration>(value: motionData.gravity.x, unit: .gravity)
    let gravityY = Measurement<UnitAcceleration>(value: motionData.gravity.y, unit: .gravity)
    let gravityZ = Measurement<UnitAcceleration>(value: motionData.gravity.z, unit: .gravity)
    return Vector(x: gravityX, y: gravityY, z: gravityZ)
  }
  
  public func calculateUserAcceleration(from motionData: CMDeviceMotion) -> Vector<UnitAcceleration> {
    let userAccelerationX = Measurement<UnitAcceleration>(value: motionData.userAcceleration.x, unit: .gravity)
    let userAccelerationY = Measurement<UnitAcceleration>(value: motionData.userAcceleration.y, unit: .gravity)
    let userAccelerationZ = Measurement<UnitAcceleration>(value: motionData.userAcceleration.z, unit: .gravity)
    return Vector(x: userAccelerationX, y: userAccelerationY, z: userAccelerationZ)
  }
  
  public func calculateHeading(from motionData: CMDeviceMotion) -> Measurement<UnitAngle> {
    Measurement<UnitAngle>(value: motionData.heading, unit: .degrees)
  }
}
