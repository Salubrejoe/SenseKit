
import Foundation
import CoreMotion

@Observable
public class ActivityManager {
  public static let stream = ActivityManager()
  
  public let activityManager = CMMotionActivityManager()
  
  public var activity      : CMMotionActivity?
  public var activityString: String {
    guard let activity else { return "No activity" }
    
    switch true {
    case activity.walking:
      return "Walking"
    case activity.running:
      return "Running"
    case activity.cycling:
      return "Cycling"
    case activity.automotive:
      return "Driving"
    case activity.stationary:
      return "Stationary"
    default:
      return "Unknown activity"
    }
  }
  
  init() {
    do {
      try startActivityUpdates()
    } catch {
      handleError(ActivityManagerError.unknownError(error))
    }
  }
  
  deinit { activityManager.stopActivityUpdates() }
  
  public func startActivityUpdates() throws {
    guard CMMotionActivityManager.isActivityAvailable() else {
      throw ActivityManagerError.activityManagerUnavailable
    }
    
    activityManager.stopActivityUpdates()
    
    activityManager.startActivityUpdates(to: .main) { [weak self] activity in
      if let activity { self?.activity = activity }
    }
  }
}


public enum ActivityManagerError: Error {
  case activityManagerUnavailable
  case unknownError(Error)
}

public extension ActivityManager {
  func handleError(_ error: Error) {
    print("ActivityError occurred: \(error)")
  }
}
