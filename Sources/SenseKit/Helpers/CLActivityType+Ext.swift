
import CoreLocation


public extension CLActivityType {
  var description: String {
    switch self {
    case .other:
      "Other"
    case .automotiveNavigation:
      "Driving"
    case .fitness:
      "Fitness"
    case .otherNavigation:
      "Other Navigation"
    case .airborne:
      "Flying"
    @unknown default:
      "Unknown"
    }
  }
}
