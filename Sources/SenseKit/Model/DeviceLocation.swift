
import CoreLocation
import SwiftUI
import MapKit


public struct DeviceLocation {
  
  public var timestamp     : Date
  public var coordinates   : DeviceCoordinates
  public var altitude      : GPSAltitude
  public var floor         : Int?
  public var speed         : Measurement<UnitSpeed>
  public var speedAccuracy : Measurement<UnitSpeed>
  
  public init() {
    self.timestamp     = .now
    self.coordinates   = .zero
    self.altitude      = .zero
    self.floor         = .zero
    self.speed         = .init(value: 0, unit: .metersPerSecond)
    self.speedAccuracy = .init(value: 0, unit: .metersPerSecond)
  }
  
 public  init(fromCL location: CLLocation) {
    
    let coordinates = DeviceCoordinates(
      longitude : Measurement(value: location.coordinate.longitude.roundTo(places: 2), unit: .degrees),
      latitude  : Measurement(value: location.coordinate.latitude.roundTo(places: 2),  unit: .degrees),
      uncertaintyRadius: Measurement(value: location.horizontalAccuracy.rounded(), unit: .meters)
    )
    
    let altitude = GPSAltitude(
      altitude: Measurement(value: location.altitude.rounded(), unit: .meters),
      ellipsoidalAltitude: Measurement(value: location.ellipsoidalAltitude.rounded(), unit: .meters),
      verticalUncertainty: Measurement(value: location.verticalAccuracy.rounded(), unit: .meters)
    )
    
    self.coordinates = coordinates
    self.altitude = altitude
    self.floor = location.floor?.level
    self.timestamp = location.timestamp
    self.speed = Measurement(value: location.speed, unit: .metersPerSecond)
    self.speedAccuracy = Measurement(value: location.speedAccuracy, unit: .metersPerSecond)
  }
}


public struct DeviceCoordinates {
  static public let zero: DeviceCoordinates = .init()
  
  public var longitude         : Measurement<UnitAngle>  = .init(value: 0.0, unit: .degrees)
  public var latitude          : Measurement<UnitAngle>  = .init(value: 0.0, unit: .degrees)
  public var uncertaintyRadius : Measurement<UnitLength> = .init(value: 0.0, unit: .meters)
  
  public var coordinates2D: CLLocationCoordinate2D {
    .init(latitude: latitude.value, longitude: longitude.value)
  }
  
  public var span: MKCoordinateSpan {
    .init(latitudeDelta: .greatestFiniteMagnitude, longitudeDelta: .greatestFiniteMagnitude)
  }
  
  public var mkRegion: MKCoordinateRegion {
    .init(center: coordinates2D, span: span)
  }
}

public struct GPSAltitude {
  static public let zero: GPSAltitude = .init()
  
  public var altitude            : Measurement<UnitLength> = .init(value: 0.0, unit: .meters)
  public var ellipsoidalAltitude : Measurement<UnitLength> = .init(value: 0.0, unit: .meters)
  public var verticalUncertainty : Measurement<UnitLength> = .init(value: 0.0, unit: .meters)
}
