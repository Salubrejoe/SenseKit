import CoreLocation

/// A structure representing heading information, including true and magnetic headings.
@MainActor
public struct SKLocationHeading {
  
  /// A constant representing zero heading with zero accuracy.
  static public let zero: SKLocationHeading = .init()
  
  /// The true heading measured in degrees, indicating the direction relative to true north.
  public var trueHeading: Measurement<UnitAngle>
  
  /// The magnetic heading measured in degrees, indicating the direction relative to magnetic north.
  public var magneticHeading: Measurement<UnitAngle>
  
  /// The accuracy of the heading measurement in degrees.
  public var headingAccuracy: Measurement<UnitAngle>
  
  /// Initializes a `Heading` instance with zero values for true heading, magnetic heading, and heading accuracy.
  public init() {
    self.trueHeading = .zeroDegrees
    self.magneticHeading = .zeroDegrees
    self.headingAccuracy = .zeroDegrees
  }
  
  /// Initializes a `SKLocationHeading` instance based on a `CLHeading` object.
  /// - Parameter newHeading: A `CLHeading` object that contains heading information.
  public init(from newHeading: CLHeading) {
    self.trueHeading = Measurement(value: newHeading.trueHeading.rounded(), unit: UnitAngle.degrees)
    self.magneticHeading = Measurement(value: newHeading.magneticHeading.rounded(), unit: UnitAngle.degrees)
    self.headingAccuracy = Measurement(value: newHeading.headingAccuracy.rounded(), unit: UnitAngle.degrees)
  }
}
