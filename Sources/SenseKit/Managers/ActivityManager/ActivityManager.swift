import CoreMotion


/// `ActivityManager` is a singleton class responsible for managing and observing device activity updates using Core Motion's `CMMotionActivityManager`.
/// It provides real-time information on the current device activity (e.g., walking, running, driving) by generating `CurrentActivity` objects.
@Observable
public class ActivityManager {
  public static let stream = ActivityManager()
  
  /// Instance of `CMMotionActivityManager` responsible for tracking device activity.
  public let activityManager = CMMotionActivityManager()
  
  /// The latest observed `CurrentActivity` object, updated in real-time.
  public var currentActivity: CurrentActivity?
  
  
  // MARK: - INIT
  /// Initializes the `ActivityManager` and attempts to start activity monitoring.
  /// - Note: If activity monitoring fails, it calls `handleError` to print the error.
  init() {
    do {
      try startActivityUpdates()
    } catch {
      handleError(ActivityManagerError.unknownError(error))
    }
  }
  
  deinit { activityManager.stopActivityUpdates() }
  
  /// Starts monitoring device activity updates using `CMMotionActivityManager`.
  /// - Throws: `ActivityManagerError.activityManagerUnavailable` if activity monitoring is unsupported.
  /// - Note: Stops any existing activity updates before starting a new session.
  public func startActivityUpdates() throws {
    guard CMMotionActivityManager.isActivityAvailable() else {
      throw ActivityManagerError.activityManagerUnavailable
    }
    
    activityManager.stopActivityUpdates()
    
    activityManager.startActivityUpdates(to: .main) { [weak self] activity in
      self?.currentActivity = CurrentActivity(from: activity)
    }
  }
}



// MARK: - ERROR
/// Defines errors for `ActivityManager`.
public enum ActivityManagerError: Error {
  case activityManagerUnavailable
  case unknownError(Error)
}

public extension ActivityManager {
  /// Handles errors by printing them to the console for debugging purposes.
  /// - Parameter error: The error encountered in `ActivityManager`.
  func handleError(_ error: Error) {
    print("ActivityError occurred: \(error)")
  }
}
