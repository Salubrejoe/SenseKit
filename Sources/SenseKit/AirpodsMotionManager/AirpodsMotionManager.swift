
import CoreMotion

@Observable
public class AirpodsMotionManager {
  public static let stream = MotionManager()
  
  public let updateInterval = 0.2
  
  public let motion = CMHeadphoneMotionManager()
 
  public var attitude         : Vector<UnitAngle>?
  public var rotationRate     : Vector<UnitAngularVelocity>?
  public var gravity          : Vector<UnitAcceleration>?
  public var userAcceleration : Vector<UnitAcceleration>?
  public var heading          : Measurement<UnitAngle>?
  
  init() {
    do {
      try startDeviceMotionUpdates()
    } catch {
      handleError(AirpodsMotionManagerError.unknownError(error))
    }
  }
  
  deinit { motion.stopDeviceMotionUpdates() }
}



public extension AirpodsMotionManager {
  
  func startDeviceMotionUpdates() throws {
    guard motion.isDeviceMotionAvailable else {
      throw AirpodsMotionManagerError.deviceMotionUnavailable
    }
    
    motion.startDeviceMotionUpdates(to: .main) { motionData, error in
      guard let motionData else { return }
      
      DispatchQueue.main.async { [weak self] in
        self?.process(motionData)
      }
    }
  }
  
  func process(_ motionData: CMDeviceMotion) {
    self.attitude         = DeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = DeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = DeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = DeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
    self.heading          = DeviceMotionCalculator.shared.calculateHeading(from: motionData)
  }
  
  func handleError(_ error: Error) {
    print("AirpodsMotionError occurred: \(error)")
  }
}


public enum AirpodsMotionManagerError: Error {
  case deviceMotionUnavailable
  case unknownError(Error)
}

