import CoreLocation

/// A structure representing heading information, including true and magnetic headings.
public struct SKLocationHeading: Sendable {

  public var trueHeading: Measurement<UnitAngle>
  public var magneticHeading: Measurement<UnitAngle>
  public var headingAccuracy: Measurement<UnitAngle>
  
  
  // MARK: - Initializers
  ///
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
