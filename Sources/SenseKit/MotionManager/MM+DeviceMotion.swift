
import CoreMotion


public extension MotionManager {
  
  func startDeviceMotion() throws {
    guard motion.isDeviceMotionAvailable else {
      throw MotionManagerError.deviceMotionUnavailable
    }
    
    self.motion.deviceMotionUpdateInterval = updateInterval
    self.motion.showsDeviceMovementDisplay = true
    
    self.motion.startDeviceMotionUpdates(to: .init()) { motionData, error in
      guard let motionData else { return }
      
      DispatchQueue.main.async { [weak self] in
        self?.process(motionData)
      }
    }
  }
  
  private func process(_ motionData: CMDeviceMotion) {
    self.attitude         = DeviceMotionCalculator.shared.calculateAttitude(from: motionData)
    self.rotationRate     = DeviceMotionCalculator.shared.calculateRotationRate(from: motionData)
    self.gravity          = DeviceMotionCalculator.shared.calculateGravity(from: motionData)
    self.userAcceleration = DeviceMotionCalculator.shared.calculateUserAcceleration(from: motionData)
    self.heading          = DeviceMotionCalculator.shared.calculateHeading(from: motionData)
    let field = motionData.magneticField.field
    let x = Measurement<UnitMagneticField>(value: field.x.magnitude, unit: .microteslas)
    let y = Measurement<UnitMagneticField>(value: field.y.magnitude, unit: .microteslas)
    let z = Measurement<UnitMagneticField>(value: field.z.magnitude, unit: .microteslas)
    let magnetometer = Vector(x: x, y: y, z: z)
    self.magnetometer = magnetometer
  }
}
