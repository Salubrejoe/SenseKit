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
    self.attitude = SKDeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate = SKDeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity = SKDeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = SKDeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
    self.heading = SKDeviceMotionCalculator.shared.calculateHeading(from: motionData)
  }
}


// MARK: - Double Properties
public extension SKHeadphonesMotionSensor {
  
  /// Returns the current attitude values with specified significant digits.
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: The current attitude values.
  func attitudeValue(significantDigits: Int = 1) -> SKVector.Components {
    attitude.components(significantDigits: significantDigits)
  }
  
  /// Returns the current rotation rate values with specified significant digits.
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: The current rotation rate values.
  func rotationRateValue(significantDigits: Int = 2) -> SKVector.Components {
    rotationRate.components(significantDigits: significantDigits)
  }
  
  /// Returns the current gravity values with specified significant digits.
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: The current gravity values.
  func gravityValue(significantDigits: Int = 1) -> SKVector.Components {
    gravity.components(significantDigits: significantDigits)
  }
  
  /// Returns the current user acceleration values with specified significant digits.
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: The current user acceleration values.
  func userAccelerationValue(significantDigits: Int = 1) -> SKVector.Components {
    userAcceleration.components(significantDigits: significantDigits)
  }
  
  /// Returns the current heading value rounded to the specified number of significant digits.
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: The current heading value.
  func headingValue(significantDigits: Int = 0) -> Double {
    heading.value.roundTo(places: significantDigits)
  }
}


// MARK: - String Properties Descriptors
public extension SKHeadphonesMotionSensor {
  
  /// Returns string descriptors for the current attitude values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptors for the attitude.
  func attitudeDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> SKVector.Descriptors {
    attitude.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns string descriptors for the current gravity values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptors for the gravity.
  func gravityDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> SKVector.Descriptors {
    gravity.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns string descriptors for the current user acceleration values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptors for the user acceleration.
  func userAccelerationDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> SKVector.Descriptors {
    userAcceleration.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns string descriptors for the current rotation rate values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptors for the rotation rate.
  func rotationRateDescriptors(significantDigits: Int = 2, includeUnit: Bool = true) -> SKVector.Descriptors {
    rotationRate.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns a string descriptor for the current heading value.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptor for the heading.
  func headingDescriptors(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    heading.description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  // MARK: - Magnitude Descriptors
  /// Returns a string descriptor for the magnitude of the current attitude values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptor for the attitude magnitude.
  func attitudeMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    attitude.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns a string descriptor for the magnitude of the current gravity values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptor for the gravity magnitude.
  func gravityMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    gravity.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns a string descriptor for the magnitude of the current user acceleration values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptor for the user acceleration magnitude.
  func userAccelerationMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    userAcceleration.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  /// Returns a string descriptor for the magnitude of the current rotation rate values.
  /// - Parameters:
  ///   - significantDigits: The number of significant digits to round to.
  ///   - includeUnit: A boolean indicating whether to include the unit in the output.
  /// - Returns: The string descriptor for the rotation rate magnitude.
  func rotationRateMagnitudeDescriptor(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    rotationRate.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
}


// MARK: - Error Handling
/// An enumeration of possible errors that can occur with the `SKHeadphonesMotionSensor`.
public enum SKHeadphonesMotionSensorError: Error {
  case deviceMotionUnavailable
  case unknownError(Error)
}
