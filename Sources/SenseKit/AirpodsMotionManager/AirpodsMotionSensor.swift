
import CoreMotion

@Observable
public class AirpodsMotionSensor {
  public static let stream = AirpodsMotionSensor()

  public let motionManager = CMHeadphoneMotionManager()

  init() { start() }
  
  deinit { stop() }
}


// MARK: - .init() HELPERS
public extension AirpodsMotionSensor {
  func start() {
    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates()
    }
  }
  
  func stop() {
    motionManager.stopDeviceMotionUpdates()
  }
  
  func handleError(_ error: Error) {
    print("MotionError occurred: \(error)")
  }
}

// MARK: - Properties
public extension AirpodsMotionSensor {
  
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
  
  var heading: Measurement<UnitAngle> {
    guard let heading = motionManager.deviceMotion?.heading else {
      return Measurement<UnitAngle>(value: 0, unit: .degrees)
    }
    return Measurement<UnitAngle>(value: heading.roundTo(places: 2), unit: .degrees)
  }
}



public enum AirpodsMotionManagerError: Error {
  case deviceMotionUnavailable
  case unknownError(Error)
}

