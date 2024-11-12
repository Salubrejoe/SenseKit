import CoreMotion

/// `SKMotionSensor` provides an interface for accessing motion and environmental data from the device's sensors,
/// including attitude, gravity, user acceleration, magnetometer, and rotation rate. It manages the configuration
/// and updates from the device's `CMMotionManager`.
///
/// - Note: `SKMotionSensor` is a singleton, accessible via `SKMotionSensor.stream`.

@MainActor
@Observable
public class SKMotionSensor {
  /// Singleton instance of `SKMotionSensor`.
  public static let stream = SKMotionSensor()
  
  
  /// The motion manager responsible for accessing motion data.
  public let motion = CMMotionManager()
  
  /// Observed Properties
  public var attitude         : SKVector<UnitAngle> = .zero
  public var gravity          : SKVector<UnitAcceleration> = .zero
  public var userAcceleration : SKVector<UnitAcceleration> = .zero
  public var magnetometer     : SKVector<UnitMagneticField> = .zero
  public var rotationRate     : SKVector<UnitAngularVelocity> = .zero
  
  
  /// The update interval for sensor data, in seconds.
  public var updateInterval: TimeInterval {
    get { motion.deviceMotionUpdateInterval }
    set {
      motion.deviceMotionUpdateInterval = newValue
      motion.accelerometerUpdateInterval = newValue
      motion.magnetometerUpdateInterval = newValue
    }
  }
  
  /// Initializes a new `SKMotionSensor` instance with an optional update interval.
  /// - Parameter updateInterval: The interval for sensor updates, defaulting to 0.1 seconds.
  init(updateInterval: TimeInterval = 0.2) {
    self.updateInterval = updateInterval
    start()
  }
  
  /// Stops all sensor updates.
  public func stop() {
    motion.stopMagnetometerUpdates()
    motion.stopDeviceMotionUpdates()
    if motion.isAccelerometerAvailable {
      motion.stopAccelerometerUpdates()
    }
  }
}

// MARK: - Initialization Helpers
public extension SKMotionSensor {
  
  /// Starts motion and magnetometer updates.
  func start() {
    do {
      try startDeviceMotion()
      try startMagnetometer()
    } catch {
      handleError(error)
    }
  }
  
  /// Handles any errors that occur during sensor initialization or updates.
  /// - Parameter error: The error encountered.
  func handleError(_ error: Error) {
    print("MotionError occurred: \(error)")
  }
}

// MARK: - Start DeviceMotion
public extension SKMotionSensor {
  
  /// Starts device motion updates, including attitude, gravity, and user acceleration.
  /// - Throws: `SKMotionSensorError.deviceMotionUnavailable` if device motion is unavailable.
  func startDeviceMotion() throws {
    guard motion.isDeviceMotionAvailable else {
      throw SKMotionSensorError.deviceMotionUnavailable
    }
    
    motion.startDeviceMotionUpdates(to: .current!) { [weak self] motionData, error in
      guard let motionData = motionData else {
        if let error = error { self?.handleError(error) }
        return
      }
      
      DispatchQueue.main.async {
        self?.process(motionData)
      }
    }
  }
  
  /// Processes `CMDeviceMotion` data to update the attitude, rotation rate, gravity, and user acceleration properties.
  /// - Parameter motionData: The `CMDeviceMotion` data to process.
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = SKDeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = SKDeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = SKDeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = SKDeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
  }
}

// MARK: - Start Magnetometer
public extension SKMotionSensor {
  
  /// Starts magnetometer updates to provide data on the magnetic field vector.
  /// - Throws: `SKMotionSensorError.magnetometerUnavailable` if the magnetometer is unavailable.
  func startMagnetometer() throws {
    guard motion.isMagnetometerAvailable else {
      throw SKMotionSensorError.magnetometerUnavailable
    }
    
    motion.magnetometerUpdateInterval = updateInterval
    motion.showsDeviceMovementDisplay = true
    
    motion.startMagnetometerUpdates(to: .current!) { [weak self] data, error in
      guard let data = data else { return }
      DispatchQueue.main.async {
        self?.magnetometer = SKVector(
          x: Measurement(value: data.magneticField.x, unit: .microteslas),
          y: Measurement(value: data.magneticField.y, unit: .microteslas),
          z: Measurement(value: data.magneticField.z, unit: .microteslas)
        )
      }
    }
  }
}


// MARK: - ERROR
/// `SKMotionSensorError` defines specific errors related to motion sensor operations within the `SKMotionSensor` class.
/// These errors represent the states where specific motion features are unavailable or when unexpected issues occur.
public enum SKMotionSensorError: Error {
  
  /// Indicates that the motion sensors (general) are unavailable on this device.
  case motionUnavailable
  
  /// Indicates that device motion updates (attitude, rotation rate, gravity, etc.) are unavailable on this device.
  case deviceMotionUnavailable
  
  /// Indicates that the magnetometer (magnetic field sensor) is unavailable on this device.
  case magnetometerUnavailable
  
  /// Represents an unknown or unexpected error.
  /// - Parameter error: The underlying error encountered.
  case unknownError(Error)
}
