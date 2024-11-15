import CoreLocation

/// A structure representing a snapshot of location data at a specific point in time.
public struct SKLocationSnapshot: Sendable {
  
  public var timestamp     : Date
  public var coordinates   : SKCoordinates
  public var altitude      : SKLocationAltitude
  public var speed         : Measurement<UnitSpeed>
  public var speedAccuracy : Measurement<UnitSpeed>
  public var floor         : Int?
  
  /// Initializes a `LocationSnapshot` instance with zero or default values.
  public init() {
    self.timestamp     = .now
    self.coordinates   = SKCoordinates()
    self.altitude      = SKLocationAltitude()
    self.speed         = .zeroMetersPerSecond
    self.speedAccuracy = .zeroMetersPerSecond
    self.floor         = nil
  }
  
  /// Initializes a `SKLocationSnapshot` instance using a `CLLocation` object.
  /// - Parameter location: A `CLLocation` object that provides location data.
  public init(from location: CLLocation) {
    self.timestamp     = location.timestamp
    self.coordinates   = .init(from: location)
    self.altitude      = .init(from: location)
    self.speed         = .init(value: location.speed, unit: .metersPerSecond)
    self.speedAccuracy = .init(value: location.speedAccuracy, unit: .metersPerSecond)
    self.floor         = location.floor?.level
  }
}
