
import CoreMotion


@Observable
public class MotionSensor {
  public static let stream = MotionSensor()
  
  public let motion = CMMotionManager()
  
  public var attitude         : Vector<UnitAngle> = .zero
  public var gravity          : Vector<UnitAcceleration> = .zero
  public var userAcceleration : Vector<UnitAcceleration> = .zero
  public var magnetometer     : Vector<UnitMagneticField> = .zero
  public var rotationRate     : Vector<UnitAngularVelocity> = .zero
  
  init(updateInterval: TimeInterval = 0.1) {
    self.updateInterval = updateInterval
    start()
  }
  
  deinit { stop() }
  
  public var updateInterval: TimeInterval {
    get {
      motion.deviceMotionUpdateInterval
    }
    set {
      motion.deviceMotionUpdateInterval  = newValue
      motion.accelerometerUpdateInterval = newValue
      motion.magnetometerUpdateInterval  = newValue
    }
  }
}



// MARK: - .init() HELPERS
public extension MotionSensor {
  
  func start() {
    do {
      try startDeviceMotion()
      try startMagnetometer()
    } catch {
      handleError(error)
    }
  }
  
  func stop() {
    motion.stopMagnetometerUpdates()
    motion.stopDeviceMotionUpdates()
    if motion.isAccelerometerAvailable {
      motion.stopAccelerometerUpdates()
    }
  }
  
  func handleError(_ error: Error) {
    print("MotionError occurred: \(error)")
  }
}


// MARK: - DeviceMotion
public extension MotionSensor {
  
  func startDeviceMotion() throws {
    guard motion.isDeviceMotionAvailable else {
      throw MotionSensorError.deviceMotionUnavailable
    }
    
    self.motion.startDeviceMotionUpdates(to: .current!) { [weak self] motionData, error in
      guard let motionData else {
        if let error {
          self?.handleError(error)
          return
        }
        return
      }
      
      DispatchQueue.main.async {
        self?.process(motionData)
      }
    }
  }
  
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = DeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = DeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = DeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = DeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
  }
}


// MARK: - Magnetometer
public extension MotionSensor {
  
  func startMagnetometer() throws {
    guard motion.isMagnetometerAvailable else {
      throw MotionSensorError.magnetometerUnavailable
    }
    
    self.motion.magnetometerUpdateInterval = updateInterval
    self.motion.showsDeviceMovementDisplay = true
    
    self.motion.startMagnetometerUpdates(to: .current!) { [weak self] data, error in
      
      guard let data else { return }
      DispatchQueue.main.async {
        self?.magnetometer = Vector(
          x: Measurement(value: data.magneticField.x, unit: .microteslas),
          y: Measurement(value: data.magneticField.y, unit: .microteslas),
          z: Measurement(value: data.magneticField.z, unit: .microteslas)
        )
      }
    }
  }
}


// MARK: - DoubleProperties
public extension MotionSensor {
  func attitudeValue(significantDigits: Int = 1) -> Vector.Components {
    attitude.components(significantDigits: significantDigits)
  }
  
  func rotationRateValue(significantDigits: Int = 2) -> Vector.Components {
    rotationRate.components(significantDigits: significantDigits)
  }
  
  func magneticFieldValue(significantDigits: Int = 0) -> Vector.Components {
    magnetometer.components(significantDigits: significantDigits)
  }
  
  func gravityValue(significantDigits: Int = 1) -> Vector.Components {
    gravity.components(significantDigits: significantDigits)
  }
  
  func userAccelerationValue(significantDigits: Int = 1) -> Vector.Components {
    userAcceleration.components(significantDigits: significantDigits)
  }
}


// MARK: - StringProperties
public extension MotionSensor {
  
  // MARK: - Computed Descriptors
  func attitudeDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    attitude.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func magneticFieldDescriptors(significantDigits: Int = 0, includeUnit: Bool = true) -> Vector.Descriptors {
    magnetometer.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
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
  
  // MARK: - Magnitude Descriptors
  func attitudeMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    attitude.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  func magneticFieldMagnitudeDescriptor(significantDigits: Int = 0, includeUnit: Bool = true) -> String {
    magnetometer.magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
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
public enum MotionSensorError: Error {
  case motionUnavailable
  case deviceMotionUnavailable
  case magnetometerUnavailable
  case unknownError(Error)
}

