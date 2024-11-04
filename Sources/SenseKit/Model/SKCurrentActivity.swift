
import CoreMotion

/// `SKCurrentActivity` is a struct that represents a snapshot of the device's activity at a specific point in time.
/// It includes details such as the activity type, start date, and confidence level.
public struct SKCurrentActivity {
  
  /// Default empty `SKCurrentActivity` instance with default values.
  public static let zero: SKCurrentActivity = .init()
  
  /// The start date of the activity.
  public var startDate: Date
  
  /// The type of activity detected, represented by `SKActivity`.
  public var activity: SKActivity
  
  /// The confidence level of the activity, represented by `CMMotionActivityConfidence`.
  public var confidence: CMMotionActivityConfidence
  
  /// Initializes a new `SKCurrentActivity` with specified parameters.
  /// - Parameters:
  ///   - startDate: The start date of the activity (default is `.distantPast`).
  ///   - activity: The type of activity (default is `.unknown`).
  ///   - confidence: The confidence level in the activity detection (default is `.low`).
  public init(
    startDate: Date = .distantPast,
    activity: SKActivity = .unknown,
    confidence: CMMotionActivityConfidence = .low
  ) {
    self.startDate = startDate
    self.activity = activity
    self.confidence = confidence
  }
  
  /// Initializes a `SKCurrentActivity` from an optional `CMMotionActivity` object.
  /// - Parameter activity: The `CMMotionActivity` from which to derive `SKCurrentActivity` values.
  /// - Note: If `activity` is `nil`, assigns default values using `SKCurrentActivity.zero`.
  public init(from activity: CMMotionActivity?) {
    if let activity {
      var coreMotionActivity: SKActivity = .unknown
      
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


