
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


public struct DeviceCoordinates {
  static public let zero: DeviceCoordinates = .init()
  
  public var longitude         : Double = 0
  public var latitude          : Double = 0
  public var uncertaintyRadius : Double = 0
  
  public var coordinates2D: CLLocationCoordinate2D {
    .init(latitude: latitude, longitude: longitude)
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
  
  public var altitude            : Double = .zero
  public var ellipsoidalAltitude : Double = .zero
  public var verticalUncertainty : Double = .zero
}
