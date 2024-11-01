
import CoreMotion

@Observable
public class AirpodsMotionSensor {
  public static let stream = AirpodsMotionSensor()
  
  public let motionManager = CMHeadphoneMotionManager()
  
  public var attitude         : Vector<UnitAngle> = .zero
  public var gravity          : Vector<UnitAcceleration> = .zero
  public var userAcceleration : Vector<UnitAcceleration> = .zero
  public var rotationRate     : Vector<UnitAngularVelocity> = .zero
  public var heading          : Measurement<UnitAngle> = .zeroDegrees
  
  init() {
    do {
      try start()
    } catch {
      handleError(error)
    }
  }
  
  deinit { stop() }
}


// MARK: - .init() HELPERS
public extension AirpodsMotionSensor {
  
  func start() throws {
    guard motionManager.isDeviceMotionAvailable else {
      throw AirpodsMotionManagerError.deviceMotionUnavailable
    }
    
    motionManager.startDeviceMotionUpdates(to: .current!) { [weak self] motionData, error in
      guard let motionData else {
        if let error {
          self?.handleError(error)
          return
        }
        return
      }
    }
    
  }
  
  func stop() {
    motionManager.stopDeviceMotionUpdates()
  }
  
  func handleError(_ error: Error) {
    print("AirpodsMotionError occurred: \(error)")
  }
  
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = DeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = DeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = DeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = DeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
    self.heading          = DeviceMotionCalculator.shared.calculateHeading(from: motionData)  }
}

// MARK: - DoubleProperties
public extension AirpodsMotionSensor {
  func attitudeValue(significantDigits: Int = 1) -> Vector.Components {
    attitude.components(significantDigits: significantDigits)
  }
  
  func rotationRateValue(significantDigits: Int = 2) -> Vector.Components {
    rotationRate.components(significantDigits: significantDigits)
  }
  
  func gravityValue(significantDigits: Int = 1) -> Vector.Components {
    gravity.components(significantDigits: significantDigits)
  }
  
  func userAccelerationValue(significantDigits: Int = 1) -> Vector.Components {
    userAcceleration.components(significantDigits: significantDigits)
  }
  func headingValue(significantDigits: Int = 0) -> Double {
    heading.value.roundTo(places: significantDigits)
  }
}


// MARK: - StringProperties Descriptors
public extension AirpodsMotionSensor {
  
  func attitudeDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    attitude.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }

  func gravityDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    gravity.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func userAccelerationDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    userAcceleration.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func rotationRateDescriptors(significantDigits: Int = 2, includeUnit: Bool = true) -> Vector.Descriptors {
    rotationRate.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func headingDescriptors(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    heading.description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  // MARK: - Magnitude Descriptors
  func attitudeMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    attitude.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func gravityMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    gravity.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func userAccelerationMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    userAcceleration.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func rotationRateMagnitudeDescriptor(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    rotationRate.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
}


// MARK: - ERROR
public enum AirpodsMotionManagerError: Error {
  case deviceMotionUnavailable
  case unknownError(Error)
}

