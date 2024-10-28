
import Foundation
import CoreMotion


extension MotionManager {
  
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
  
  public func startActivityUpdates() throws {
    guard CMMotionActivityManager.isActivityAvailable() else {
      throw MotionManagerError.activityManagerUnavailable
    }
    
    activityManager.startActivityUpdates(to: mainQueue) { [weak self] activity in
      if let activity { self?.activity = activity }
    }
  }
}
