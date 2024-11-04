import CoreMotion


/// `SKActivityManager` is a singleton class responsible for managing and observing device activity updates using Core Motion's `CMMotionActivityManager`.
/// It provides real-time information on the current device activity (e.g., walking, running, driving) by generating `SKCurrentActivity` objects.
@Observable
public class SKActivityManager {
  public static let stream = SKActivityManager()
  
  /// Instance of `CMMotionActivityManager` responsible for tracking device activity.
  public let activityManager = CMMotionActivityManager()
  
  /// The latest observed `SKCurrentActivity` object, updated in real-time.
  public var currentActivity: SKCurrentActivity?
  
  
  // MARK: - INIT
  /// Initializes the `SKActivityManager` and attempts to start activity monitoring.
  /// - Note: If activity monitoring fails, it calls `handleError` to print the error.
  init() {
    do {
      try startActivityUpdates()
    } catch {
      handleError(SKActivityManagerError.unknownError(error))
    }
  }
  
  deinit { activityManager.stopActivityUpdates() }
  
  /// Starts monitoring device activity updates using `CMMotionActivityManager`.
  /// - Throws: `SKActivityManagerError.activityManagerUnavailable` if activity monitoring is unsupported.
  /// - Note: Stops any existing activity updates before starting a new session.
  public func startActivityUpdates() throws {
    guard CMMotionActivityManager.isActivityAvailable() else {
      throw SKActivityManagerError.activityManagerUnavailable
    }
    
    activityManager.stopActivityUpdates()
    
    activityManager.startActivityUpdates(to: .main) { [weak self] activity in
      self?.currentActivity = SKCurrentActivity(from: activity)
    }
  }
}

public extension SKActivityManager {
  /// Handles errors by printing them to the console for debugging purposes.
  /// - Parameter error: The error encountered in `SKActivityManager`.
  func handleError(_ error: Error) {
    print("ActivityError occurred: \(error)")
  }
}




// MARK: - ERROR
/// Defines errors for `SKActivityManager`.
public enum SKActivityManagerError: Error {
  case activityManagerUnavailable
  case unknownError(Error)
}
