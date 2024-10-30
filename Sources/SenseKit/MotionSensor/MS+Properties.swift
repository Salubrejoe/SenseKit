
import CoreMotion


public extension MotionSensor {
  
  var attitude: Vector<UnitAngle> {
    guard let attitude = motionManager.deviceMotion?.attitude else {
      return Vector()
    }
    return Vector(
      x: Measurement<UnitAngle>(value: attitude.pitch.roundTo(places: 2), unit: .radians),
      y: Measurement<UnitAngle>(value: attitude.roll.roundTo(places: 2), unit: .radians),
      z: Measurement<UnitAngle>(value: attitude.yaw.roundTo(places: 2), unit: .radians)
    )
  }
  
  var rotationRate: Vector<UnitAngularVelocity> {
    guard let rotationRate = motionManager.deviceMotion?.rotationRate else {
      return Vector()
    }
    return Vector(
      x: Measurement<UnitAngularVelocity>(value: rotationRate.x.roundTo(places: 2), unit: .radiansPerSecond),
      y: Measurement<UnitAngularVelocity>(value: rotationRate.y.roundTo(places: 2), unit: .radiansPerSecond),
      z: Measurement<UnitAngularVelocity>(value: rotationRate.z.roundTo(places: 2), unit: .radiansPerSecond)
    )
  }
  
  var gravity: Vector<UnitAcceleration> {
    guard let gravity = motionManager.deviceMotion?.gravity else {
      return Vector()
    }
    return Vector(
      x: Measurement<UnitAcceleration>(value: gravity.x.roundTo(places: 2), unit: .metersPerSecondSquared),
      y: Measurement<UnitAcceleration>(value: gravity.y.roundTo(places: 2), unit: .metersPerSecondSquared),
      z: Measurement<UnitAcceleration>(value: gravity.z.roundTo(places: 2), unit: .metersPerSecondSquared)
    )
  }
  
  var userAcceleration: Vector<UnitAcceleration> {
    guard let userAcceleration = motionManager.deviceMotion?.userAcceleration else {
      return Vector()
    }
    return Vector(
      x: Measurement<UnitAcceleration>(value: userAcceleration.x.roundTo(places: 2), unit: .metersPerSecondSquared),
      y: Measurement<UnitAcceleration>(value: userAcceleration.y.roundTo(places: 2), unit: .metersPerSecondSquared),
      z: Measurement<UnitAcceleration>(value: userAcceleration.z.roundTo(places: 2), unit: .metersPerSecondSquared)
    )
  }
  
  var magnetometer: Vector<UnitMagneticField> {
    guard let magneticField = motionManager.magnetometerData?.magneticField else {
      return Vector()
    }
    return Vector(
      x: Measurement<UnitMagneticField>(value: magneticField.x.roundTo(places: 2), unit: .microteslas),
      y: Measurement<UnitMagneticField>(value: magneticField.y.roundTo(places: 2), unit: .microteslas),
      z: Measurement<UnitMagneticField>(value: magneticField.z.roundTo(places: 2), unit: .microteslas)
    )
  }
  
  var heading: Measurement<UnitAngle> {
    guard let heading = motionManager.deviceMotion?.heading else {
      return Measurement<UnitAngle>(value: 0, unit: .degrees)
    }
    return Measurement<UnitAngle>(value: heading.roundTo(places: 2), unit: .degrees)
  }
  
  var updateInterval: TimeInterval {
    get {
      return motionManager.deviceMotionUpdateInterval
    }
    set {
      motionManager.deviceMotionUpdateInterval  = newValue
      motionManager.accelerometerUpdateInterval = newValue
      motionManager.magnetometerUpdateInterval  = newValue
    }
  }
}
