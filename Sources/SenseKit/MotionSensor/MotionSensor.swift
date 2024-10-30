
import CoreMotion


@Observable
public class MotionSensor {
  public static let stream = MotionSensor()
  
  public let motion = CMMotionManager()
  
  public var attitude         : Vector<UnitAngle> = .zero
  public var gravity          : Vector<UnitAcceleration> = .zero
  public var userAcceleration : Vector<UnitAcceleration> = .zero
  public var rotationRate     : Vector<UnitAngularVelocity> = .zero
  public var magnetometer     : Vector<UnitMagneticField> = .zero
  public var heading          : Measurement<UnitAngle> = .init(value: 0, unit: .degrees)
  
  
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
    motion.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { deviceMotion, error in
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
    self.heading          = DeviceMotionCalculator.shared.calculateHeading(from: motionData)
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


// MARK: - ERROR
public enum MotionSensorError: Error {
  case motionUnavailable
  case deviceMotionUnavailable
  case magnetometerUnavailable
  case unknownError(Error)
}

