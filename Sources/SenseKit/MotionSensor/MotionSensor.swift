
import CoreMotion


@Observable
public class MotionSensor {
  public static let stream = MotionSensor()
  
  public let motionManager = CMMotionManager()
  
  init(updateInterval: TimeInterval = 0.1) {
    self.updateInterval = updateInterval
    start()
  }
  
  deinit { stop() }
  
  public func setOnUpdateHandler(_ handler: @escaping () -> Void) {
    motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { deviceMotion, error in
      handler()
    })
  }
}




// MARK: - .init() HELPERS
public extension MotionSensor {
  func start() {
    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates()
    }
    
    if motionManager.isAccelerometerAvailable {
      motionManager.startAccelerometerUpdates()
    }
    
    if motionManager.isMagnetometerAvailable {
      motionManager.startMagnetometerUpdates()
    }
  }
  
  func stop() {
    motionManager.stopMagnetometerUpdates()
    motionManager.stopDeviceMotionUpdates()
    if motionManager.isAccelerometerAvailable {
      motionManager.stopAccelerometerUpdates()
    }
  }
  
  func handleError(_ error: Error) {
    print("MotionError occurred: \(error)")
  }
}


// MARK: - ERROR
public enum MotionManagerError: Error {
  case motionUnavailable
  case deviceMotionUnavailable
  case magnetometerUnavailable
  case unknownError(Error)
}

