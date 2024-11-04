
import CoreMotion


/// Enumeration of possible motion activities detected by `CMMotionActivity`.
public enum SKActivity {
  case stationary
  case walking
  case running
  case cycling
  case automotive
  case unknown
  
  /// Provides a human-readable description for each activity type.
  public var description: String {
    switch self {
    case .stationary:
      "Stationary"
    case .walking:
      "Walking"
    case .running:
      "Running"
    case .cycling:
      "Cycling"
    case .automotive:
      "Driving"
    case .unknown:
      "Unknown activity"
    }
  }
  
  /// Provides a string for the related SFSymbol
  public var symbol: String {
    switch self {
    case .stationary:
      "person.crop.circle"
    case .walking:
      "person.walking"
    case .running:
      "person.running"
    case .cycling:
      "person.cycle"
    case .automotive:
      "car.fill"
    case .unknown:
      "questionmark.circle"
    }
  }
}
