
import Foundation
import CoreMotion


@Observable
public class MotionManager {
  public static let stream = MotionManager()
   
  public let updateInterval = 0.2
  public let queue = OperationQueue()
  
  public let motion          = CMMotionManager()
  
  public var attitude         : Vector<UnitAngle>?
  public var rotationRate     : Vector<UnitAngularVelocity>?
  public var gravity          : Vector<UnitAcceleration>?
  public var userAcceleration : Vector<UnitAcceleration>?
  public var heading          : Measurement<UnitAngle>?
  public var magnetometer     : Vector<UnitMagneticField>?
  
  init() {
    do {
      try startMagnetometer()
      try startDeviceMotion()
    } catch {
      handleError(MotionManagerError.unknownError(error))
    }
  }
  
  deinit {
    motion.stopMagnetometerUpdates()
    motion.stopDeviceMotionUpdates()
  }
}


public extension MotionManager {
  func handleError(_ error: Error) {
    print("MotionError occurred: \(error)")
  }
}


public enum MotionManagerError: Error {
  case motionUnavailable
  case deviceMotionUnavailable
  case magnetometerUnavailable
  case unknownError(Error)
}

