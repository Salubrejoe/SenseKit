
import CoreMotion

/// `CurrentActivity` is a struct that represents a snapshot of the device's activity at a specific point in time.
/// It includes details such as the activity type, start date, and confidence level.
public struct CurrentActivity {
  
  /// Default empty `CurrentActivity` instance with default values.
  public static let zero: CurrentActivity = .init()
  
  /// The start date of the activity.
  public var startDate: Date
  
  /// The type of activity detected, represented by `CoreMotionActivity`.
  public var activity: CoreMotionActivity
  
  /// The confidence level of the activity, represented by `CMMotionActivityConfidence`.
  public var confidence: CMMotionActivityConfidence
  
  /// Initializes a new `CurrentActivity` with specified parameters.
  /// - Parameters:
  ///   - startDate: The start date of the activity (default is `.distantPast`).
  ///   - activity: The type of activity (default is `.unknown`).
  ///   - confidence: The confidence level in the activity detection (default is `.low`).
  public init(
    startDate: Date = .distantPast,
    activity: CoreMotionActivity = .unknown,
    confidence: CMMotionActivityConfidence = .low
  ) {
    self.startDate = startDate
    self.activity = activity
    self.confidence = confidence
  }
  
  /// Initializes a `CurrentActivity` from an optional `CMMotionActivity` object.
  /// - Parameter activity: The `CMMotionActivity` from which to derive `CurrentActivity` values.
  /// - Note: If `activity` is `nil`, assigns default values using `CurrentActivity.zero`.
  public init(from activity: CMMotionActivity?) {
    if let activity {
      var coreMotionActivity: CoreMotionActivity = .unknown
      
      if activity.stationary { coreMotionActivity = .stationary }
      else if activity.walking { coreMotionActivity = .walking }
      else if activity.running { coreMotionActivity = .running }
      else if activity.cycling { coreMotionActivity = .cycling }
      else if activity.automotive { coreMotionActivity = .automotive }
      else if activity.unknown { coreMotionActivity = .unknown }
      
      self.startDate  = activity.startDate
      self.activity   = coreMotionActivity
      self.confidence = activity.confidence
    } else {
      self = .zero
    }
  }
}

// MARK: - CoreMotionActivity

/// Enumeration of possible motion activities detected by `CMMotionActivity`.
public enum CoreMotionActivity {
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
