
import Foundation


public extension MotionManager {
  
  func startMagnetometer() throws {
    guard motion.isMagnetometerAvailable else {
      throw MotionManagerError.magnetometerUnavailable
    }
    
    self.motion.magnetometerUpdateInterval = updateInterval
    self.motion.showsDeviceMovementDisplay = true
    
    self.motion.startMagnetometerUpdates(to: self.queue) { data, error in
      
      guard let data else { return }
      DispatchQueue.main.async { [weak self] in
        self?.magnetometer = Vector(
          x: Measurement(value: data.magneticField.x, unit: .microteslas),
          y: Measurement(value: data.magneticField.y, unit: .microteslas),
          z: Measurement(value: data.magneticField.z, unit: .microteslas)
        )
      }
    }
  }
}

