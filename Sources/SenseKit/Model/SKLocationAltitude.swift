import CoreLocation

/// A structure representing altitude information derived from GPS data.
@MainActor
public struct SKLocationAltitude {
  
  /// A constant representing zero altitude values for all measurements.
  static public let zero: SKLocationAltitude = .init()
  
  /// The altitude of the device above sea level.
  public var altitude: Measurement<UnitLength>
  
  /// The ellipsoidal altitude of the device, representing height above the reference ellipsoid.
  public var ellipsoidalAltitude: Measurement<UnitLength>
  
  /// The uncertainty associated with the vertical position measurement.
  public var verticalUncertainty: Measurement<UnitLength>
  
  /// Initializes a `SKLocationAltitude` instance with zero values for all measurements.
  public init() {
    self.altitude = .zeroMeters
    self.ellipsoidalAltitude = .zeroMeters
    self.verticalUncertainty = .zeroMeters
  }
  
  /// Initializes a `SKLocationAltitude` instance based on a `CLLocation` object.
  /// - Parameter location: A `CLLocation` object that contains altitude information.
  public init(from location: CLLocation) {
    self.altitude = .init(value: location.altitude.rounded(), unit: .meters)
    self.ellipsoidalAltitude = .init(value: location.ellipsoidalAltitude.rounded(), unit: .meters)
    self.verticalUncertainty = .init(value: location.verticalAccuracy.rounded(), unit: .meters)
  }
}
