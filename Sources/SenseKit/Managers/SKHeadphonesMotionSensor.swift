import CoreMotion

/// A singleton class that provides access to motion data from AirPods using the `CMHeadphoneMotionManager`.
@Observable
public class SKHeadphonesMotionSensor {
  /// A shared instance of the `AirpodsMotionSensor`.
  public static let stream = SKHeadphonesMotionSensor()
  
  
  /// The motion manager that handles the device motion updates.
  public let motionManager = CMHeadphoneMotionManager()
  
  
  /// The current attitude of the AirPods represented as a vector of angles.
  public var attitude: SKVector<UnitAngle> = .zero
  
  /// The current gravitational acceleration vector.
  public var gravity: SKVector<UnitAcceleration> = .zero
  
  /// The current user acceleration vector.
  public var userAcceleration: SKVector<UnitAcceleration> = .zero
  
  /// The current rotation rate of the AirPods represented as a vector.
  public var rotationRate: SKVector<UnitAngularVelocity> = .zero
  
  /// The current heading of the AirPods in degrees.
  public var heading: Measurement<UnitAngle> = .zeroDegrees
  
  /// Initializes the motion sensor and starts capturing motion data.
  init() {
    do {
      try start()
    } catch {
      handleError(error)
    }
  }
  
  deinit { stop() }
}


// MARK: - Initialization Helpers
public extension SKHeadphonesMotionSensor {
  
  /// Starts capturing motion updates from the AirPods.
  /// - Throws: An error if the device motion is unavailable.
  func start() throws {
    guard motionManager.isDeviceMotionAvailable else {
      throw SKHeadphonesMotionSensorError.deviceMotionUnavailable
    }
    
    motionManager.startDeviceMotionUpdates(to: .current!) { [weak self] motionData, error in
      if let error = error {
        self?.handleError(error)
        return
      }
      
      guard let motionData = motionData else {
        print("No motion data available.")
        return
      }
      
      // Process the motion data.
      self?.process(motionData)
    }
  }
  
  /// Stops capturing motion updates from the AirPods.
  func stop() {
    motionManager.stopDeviceMotionUpdates()
  }
  
  /// Handles errors that occur during motion updates.
  /// - Parameter error: The error that occurred.
  func handleError(_ error: Error) {
    print("AirpodsMotionError occurred: \(error)")
  }
  
  /// Processes the motion data received from the motion manager.
  /// - Parameter motionData: The motion data to process.
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = SKDeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = SKDeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = SKDeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = SKDeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
    self.heading          = SKDeviceMotionCalculator.shared.calculateHeading(from: motionData)
  }
}


// MARK: - Error Handling
/// An enumeration of possible errors that can occur with the `SKHeadphonesMotionSensor`.
public enum SKHeadphonesMotionSensorError: Error {
  case deviceMotionUnavailable
  case unknownError(Error)
}
