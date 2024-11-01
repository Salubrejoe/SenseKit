
import SwiftUI


public struct AltitudeTestForm: View {
  
  @Environment(AltitudeManager.self) var altitudeManager
  
  public var body: some View {
    Form {
      absoluteAltitudeSection
      relativeAltitudeSection
      pressureSection
    }
  }
}


// MARK: - Sections
public extension AltitudeTestForm {
  
  private var absoluteAltitudeSection: some View {
    Section("Absolute Altitude") {
      if let altitude = altitudeManager.absoluteAltitude {
        Text("\(altitude.description(significantDigits: 0))")
      } else {
        Text("No data available")
      }
      
      if let accuracy = altitudeManager.absoluteAccuracy {
        Text("Accuracy: \(accuracy.description(significantDigits: 1))")
      } else {
        Text("No data available")
      }
      
      if let precision = altitudeManager.absolutePrecision {
        Text("Precision: \(precision.description(significantDigits: 1))")
      } else {
        Text("No data available")
      }
    }
  }
  
  private var relativeAltitudeSection: some View {
    Section("Relative Altitude") {
      if let relativeAltitude = altitudeManager.relativeAltitude {
        Text("\(relativeAltitude.description(significantDigits: 0))")
      } else {
        Text("Relative No data available")
      }
    }
  }
  
  private var pressureSection: some View {
    Section("Pressure") {
      if let pressure = altitudeManager.pressure {
        Text("\(pressure.description(significantDigits: 2))")
      } else {
        Text("No data available")
      }
    }
  }
}
