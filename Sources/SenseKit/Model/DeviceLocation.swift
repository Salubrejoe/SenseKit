
import CoreLocation
import SwiftUI
import MapKit


public struct DeviceLocation {
  
  var coordinates   : DeviceCoordinates
  var altitude      : GPSAltitude
  var floor         : Int?
  var speed         : Measurement<UnitSpeed>
  var speedAccuracy : Measurement<UnitSpeed>
  var timestamp     : Date
  
  init() {
    self.timestamp     = .now
    self.coordinates   = .zero
    self.altitude      = .zero
    self.floor         = .zero
    self.speed         = .init(value: 0, unit: .metersPerSecond)
    self.speedAccuracy = .init(value: 0, unit: .metersPerSecond)
  }
  
  init(fromCL location: CLLocation) {
    
    let coordinates = DeviceCoordinates(
      longitude: location.coordinate.longitude,
      latitude: location.coordinate.latitude,
      uncertaintyRadius: location.horizontalAccuracy
    )
    
    let altitude = GPSAltitude(
      altitude: location.altitude,
      ellipsoidalAltitude: location.ellipsoidalAltitude,
      verticalUncertainty: location.verticalAccuracy
    )
    
    self.coordinates = coordinates
    self.altitude = altitude
    self.floor = location.floor?.level
    self.timestamp = location.timestamp
    self.speed = Measurement(value: location.speed, unit: .metersPerSecond)
    self.speedAccuracy = Measurement(value: location.speedAccuracy, unit: .metersPerSecond)
  }
}


struct DeviceCoordinates {
  static let zero: DeviceCoordinates = .init()
  
  var longitude         : Double = 0
  var latitude          : Double = 0
  var uncertaintyRadius : Double = 0
  
  var coordinates2D: CLLocationCoordinate2D {
    .init(latitude: latitude, longitude: longitude)
  }
  
  var span: MKCoordinateSpan {
    .init(latitudeDelta: .greatestFiniteMagnitude, longitudeDelta: .greatestFiniteMagnitude)
  }
  
  var mkRegion: MKCoordinateRegion {
    .init(center: coordinates2D, span: span)
  }
}

struct GPSAltitude {
  static let zero: GPSAltitude = .init()
  
  var altitude            : Double = .zero
  var ellipsoidalAltitude : Double = .zero
  var verticalUncertainty : Double = .zero
}
