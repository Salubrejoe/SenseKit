
import Foundation


/// `MotionSensorError` defines specific errors related to motion sensor operations within the `MotionSensor` class.
/// These errors represent the states where specific motion features are unavailable or when unexpected issues occur.
public enum MotionSensorError: Error {
  
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
