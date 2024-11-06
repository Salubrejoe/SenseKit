import CoreLocation

/// A structure representing a snapshot of location data at a specific point in time.
@MainActor
public struct SKLocationSnapshot {
  
  /// A constant representing a zero-initialized `SKLocationSnapshot`.
  static public let zero = SKLocationSnapshot()
  
  /// The timestamp of the location snapshot.
  public var timestamp: Date
  
  /// The geographic coordinates of the location snapshot.
  public var coordinates: SKCoordinates
  
  /// The altitude information at the time of the snapshot.
  public var altitude: SKLocationAltitude
  
  /// The speed of movement at the time of the snapshot, measured in meters per second.
  public var speed: Measurement<UnitSpeed>
  
  /// The accuracy of the speed measurement, also in meters per second.
  public var speedAccuracy: Measurement<UnitSpeed>
  
  /// The floor level of the location, if available (optional).
  public var floor: Int?
  
  /// Initializes a `LocationSnapshot` instance with zero or default values.
  public init() {
    self.timestamp = .now
    self.coordinates = .zero
    self.altitude = .zero
    self.speed = .zeroMetersPerSeconds
    self.speedAccuracy = .zeroMetersPerSeconds
    self.floor = nil
  }
  
  /// Initializes a `SKLocationSnapshot` instance using a `CLLocation` object.
  /// - Parameter location: A `CLLocation` object that provides location data.
  public init(from location: CLLocation) {
    self.timestamp = location.timestamp
    self.coordinates = .init(from: location)
    self.altitude = .init(from: location)
    self.speed = .init(value: location.speed, unit: .metersPerSecond)
    self.speedAccuracy = .init(value: location.speedAccuracy, unit: .metersPerSecond)
    self.floor = location.floor?.level
  }
}
