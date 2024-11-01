
import CoreLocation


public struct GPSAltitude {
  static public let zero: GPSAltitude = .init()
  
  public var altitude            : Measurement<UnitLength>
  public var ellipsoidalAltitude : Measurement<UnitLength>
  public var verticalUncertainty : Measurement<UnitLength>
  
  public init() {
    self.altitude            = .zeroMeters
    self.ellipsoidalAltitude = .zeroMeters
    self.verticalUncertainty = .zeroMeters
  }
  
  public init(from location: CLLocation) {
    self.altitude = .init(value: location.altitude.rounded(), unit: .meters)
    self.ellipsoidalAltitude = .init(value: location.ellipsoidalAltitude.rounded(), unit: .meters)
    self.verticalUncertainty = .init(value: location.verticalAccuracy.rounded(), unit: .meters)
  }
}



