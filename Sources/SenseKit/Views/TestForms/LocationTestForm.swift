
import SwiftUI


public struct LocationTestForm: View {
  
  @Environment(Location.self) var location
  
  public var body: some View {
    Form {
      coordinatesSection
      altitudeSection
      speedSection
      floorSection
      headingSection
    }
  }
}


// MARK: - Sections
extension LocationTestForm {
  private var coordinatesSection: some View {
    Section("Coordinates") {
      if let coordinates = location.snapshot?.coordinates {
        Text("Latitude: \(coordinates.latitude.description(significantDigits: 3))")
        Text("Longitude: \(coordinates.longitude.description(significantDigits: 3))")
        Text("Uncertainty Radius: \(coordinates.uncertaintyRadius.description(significantDigits: 4))")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var altitudeSection: some View {
    Section("Altitude") {
      if let altitude = location.snapshot?.altitude {
        Text("Altitude: \(altitude.altitude.description(significantDigits: 0))")
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
        Text("Speed: \(snapshot.speed.description(significantDigits: 0))")
        Text("Speed Accuracy: \(snapshot.speedAccuracy.description(significantDigits: 1))")
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
      Text("Heading Accuracy: \(heading.headingAccuracy.description(significantDigits: 2))")
    }
  }
}
