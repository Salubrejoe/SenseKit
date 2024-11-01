
import MapKit


public struct GPSCoordinates {
  static public let zero: GPSCoordinates = .init()
  
  public var longitude         : Measurement<UnitAngle>
  public var latitude          : Measurement<UnitAngle>
  public var uncertaintyRadius : Measurement<UnitLength>
  
  public init() {
    self.longitude         = .zeroDegrees
    self.latitude          = .zeroDegrees
    self.uncertaintyRadius = .zeroMeters
  }
  
  public init(from location: CLLocation) {
    self.latitude = .init(
      value: location.coordinate.latitude.roundTo(places: 2),
      unit: .degrees
    )
    self.longitude = .init(
      value: location.coordinate.longitude.roundTo(places: 2),
      unit: .degrees
    )
    self.uncertaintyRadius = .init(
      value: location.horizontalAccuracy.rounded(),
      unit: .meters
    )
  }
  
  public var coordinates2D: CLLocationCoordinate2D {
    .init(
      latitude: latitude.value,
      longitude: longitude.value
    )
  }
  
  public var span: MKCoordinateSpan {
    .init(
      latitudeDelta: .greatestFiniteMagnitude,
      longitudeDelta: .greatestFiniteMagnitude
    )
  }
  
  public var mkRegion: MKCoordinateRegion {
    .init(
      center: coordinates2D,
      span: span
    )
  }
}
