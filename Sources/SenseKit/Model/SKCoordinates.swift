
import MapKit

// A structure for representing geographic coordinates with an associated uncertainty radius.
/// This struct uses Apple's `Measurement` API for unit-safe storage of latitude, longitude, and uncertainty radius.
public struct SKCoordinates: Sendable {

  public var longitude: Measurement<UnitAngle>
  public var latitude: Measurement<UnitAngle>
  public var uncertaintyRadius: Measurement<UnitLength>
  
  
  // MARK: - Initializers
  ///
  /// Initializes `SKCoordinates` with default values (zero for latitude, longitude, and uncertainty radius).
  public init() {
    self.longitude = .zeroDegrees
    self.latitude = .zeroDegrees
    self.uncertaintyRadius = .zeroMeters
  }
  
  /// Initializes `SKCoordinates` using a `CLLocation` object.
  /// - Parameter location: A `CLLocation` instance from which latitude, longitude, and uncertainty radius are derived.
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
  
  // MARK: - Computed Properties
  
  /// Returns the coordinates in `CLLocationCoordinate2D` format for compatibility with `MapKit`.
  public var coordinates2D: CLLocationCoordinate2D {
    .init(
      latitude: latitude.value,
      longitude: longitude.value
    )
  }
  
  /// Returns a large `MKCoordinateSpan` covering a vast area, with maximum deltas.
  public var greatestFiniteMagnitudeSpan: MKCoordinateSpan {
    .init(
      latitudeDelta: .greatestFiniteMagnitude,
      longitudeDelta: .greatestFiniteMagnitude
    )
  }
  
  /// Returns an `MKCoordinateRegion` centered on the coordinate, with a large span.
  public var mkRegion: MKCoordinateRegion {
    .init(
      center: coordinates2D,
      span: greatestFiniteMagnitudeSpan
    )
  }
}
