
import MapKit


public struct DeviceCoordinates {
  static public let zero: DeviceCoordinates = .init()
  
  public var longitude         = Measurement.zeroDegrees
  public var latitude          = Measurement.zeroDegrees
  public var uncertaintyRadius = Measurement.zeroMeters
  
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
