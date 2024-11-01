
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
  
  public func setOnUpdateHandler(_ handler: @escaping () -> Void) {
    motion.startDeviceMotionUpdates(to: .current!, withHandler: { deviceMotion, error in
      handler()
    })
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
      guard let motionData, error == nil else {
        if let error {
          self?.handleError(error)
          return
        }
        return
      }
      
      DispatchQueue.main.async { self?.process(motionData) }
    }
  }
  
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = DeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = DeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = DeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = DeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
//    self.heading          = DeviceMotionCalculator.shared.calculateHeading(from: motionData)
//    self.magnetometer     = DeviceMotionCalculator.shared.calculateMagneticFIeld(from: motionData)
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

// MARK: - Double Properties
extension MotionSensor {
  public func attitudeValue(significantDigits: Int = 1) -> Vector.Components {
    attitude.components(significantDigits: significantDigits)
  }
  
  public func rotationRateValue(significantDigits: Int = 2) -> Vector.Components {
    rotationRate.components(significantDigits: significantDigits)
  }
  
  public func magneticFieldValue(significantDigits: Int = 0) -> Vector.Components {
    magnetometer.components(significantDigits: significantDigits)
  }
  
  public func gravityValue(significantDigits: Int = 1) -> Vector.Components {
    gravity.components(significantDigits: significantDigits)
  }
  
  public func userAccelerationValue(significantDigits: Int = 1) -> Vector.Components {
    userAcceleration.components(significantDigits: significantDigits)
  }
}


// MARK: - String Properties
extension MotionSensor {
  
  // MARK: - Computed Descriptors
  public func attitudeDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    attitude.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func magneticFieldDescriptors(significantDigits: Int = 0, includeUnit: Bool = true) -> Vector.Descriptors {
    magnetometer.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func gravityDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    gravity.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func userAccelerationDescriptors(significantDigits: Int = 1, includeUnit: Bool = true) -> Vector.Descriptors {
    userAcceleration.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func rotationRateDescriptors(significantDigits: Int = 2, includeUnit: Bool = true) -> Vector.Descriptors {
    rotationRate.componentsDescriptions(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  // MARK: - Magnitude Descriptors
  public func attitudeMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    attitude.magnitudeDescription(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func magneticFieldMagnitudeDescriptor(significantDigits: Int = 0, includeUnit: Bool = true) -> String {
    magnetometer.magnitudeDescription(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func gravityMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    gravity.magnitudeDescription(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func userAccelerationMagnitudeDescriptor(significantDigits: Int = 1, includeUnit: Bool = true) -> String {
    userAcceleration.magnitudeDescription(significantDigits: significantDigits, includeUnit: includeUnit)
  }
  
  public func rotationRateMagnitudeDescriptor(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    rotationRate.magnitudeDescription(significantDigits: significantDigits, includeUnit: includeUnit)
  }
}


// MARK: - ERROR
public enum MotionSensorError: Error {
  case motionUnavailable
  case deviceMotionUnavailable
  case magnetometerUnavailable
  case unknownError(Error)
}

