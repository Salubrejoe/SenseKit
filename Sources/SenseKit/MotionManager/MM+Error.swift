
import Foundation

public extension MotionManager {
  func handleError(_ error: Error) {
    // Handle error accordingly (e.g., log the error, show alerts, etc.)
    print("Error occurred: \(error)")
  }
}


public enum MotionManagerError: Error {
  case motionUnavailable
  case headphoneMotionUnavailable
  case accelerometerUnavailable
  case gyroscopeUnavailable
  case magnetometerUnavailable
  case locationServicesDisabled
  case permissionDenied
  case altitudeUpdatesUnavailable
  case activityManagerUnavailable
  case altimeterUnavailable
  case deviceMotionUnavailable
  case unknownError(Error)
}
