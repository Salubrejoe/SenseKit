
import CoreLocation


public struct LocationSnapshot {
  static public let zero = LocationSnapshot()
  
  public var timestamp     : Date
  public var coordinates   : GPSCoordinates
  public var altitude      : GPSAltitude
  public var speed         : Measurement<UnitSpeed>
  public var speedAccuracy : Measurement<UnitSpeed>
  public var floor         : Int?
  
  public init() {
    self.timestamp     = .now
    self.coordinates   = .zero
    self.altitude      = .zero
    self.speed         = .zeroMetersPerSeconds
    self.speedAccuracy = .zeroMetersPerSeconds
    self.floor         = .zero
  }
  
  public init(from location: CLLocation) {
    self.timestamp     = location.timestamp
    self.coordinates   = .init(from: location)
    self.altitude      = .init(from: location)
    self.speed         = .init(value: location.speed, unit: .metersPerSecond)
    self.speedAccuracy = .init(value: location.speedAccuracy, unit: .metersPerSecond)
    self.floor         = location.floor?.level
  }
}


