
import SwiftUI


public struct LocationTestForm: View {
  
  @Environment(SKLocation.self) var location
  
  public var body: some View {
    Form {
      coordinatesSection
      altitudeSection
      speedSection
      floorSection
      headingSection
      activityTypeSection
    }
  }
}


// MARK: - Sections
public extension LocationTestForm {
  private var coordinatesSection: some View {
    Section("Coordinates") {
      if let coordinates = location.snapshot?.coordinates {
        Text("Latitude: \(coordinates.latitude.description(significantDigits: 2))")
        Text("Longitude: \(coordinates.longitude.description(significantDigits: 2))")
        Text("Uncertainty Radius: \(coordinates.uncertaintyRadius.description(significantDigits: 0))")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var altitudeSection: some View {
    Section("Altitude") {
      if let altitude = location.snapshot?.altitude {
        Text("Altitude: \(altitude.aboveSeaLevel.description(significantDigits: 0))")
        Text("Ellipsoidal Altitude: \(altitude.ellipsoidalAltitude.description(significantDigits: 0))")
        Text("Vertical Uncertainty: \(altitude.verticalUncertainty.description(significantDigits: 1))")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var speedSection: some View {
    Section("Speed") {
      if let snapshot = location.snapshot {
        Text("\(snapshot.speed.description(significantDigits: 0))")
        Text("Accuracy: \(snapshot.speedAccuracy.description(significantDigits: 1))")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var floorSection: some View {
    Section("Floor") {
      if let floor = location.snapshot?.floor {
        Text("Floor Level: \(floor)")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var headingSection: some View {
    Section("Heading") {
      let heading = location.heading
      Text("True Heading: \(heading.trueHeading.description(significantDigits: 0))")
      Text("Magnetic Heading: \(heading.magneticHeading.description(significantDigits: 0))")
      Text("Accuracy: \(heading.headingAccuracy.description(significantDigits: 1))")
    }
  }
  
  private var activityTypeSection: some View {
    Section("Activity") {
      Text("\(activityTypeDescription())")
    }
  }
  
  /// Helper function to get a readable activity type description.
  private func activityTypeDescription() -> String {
    switch location.activityType {
    case .automotiveNavigation: return "Automotive Navigation"
    case .fitness: return "Fitness"
    case .other: return "Other"
    case .otherNavigation: return "Other Navigation"
    case .airborne: return "Airborne"
    @unknown default: return "Unknown"
    }
  }
}
  
  
