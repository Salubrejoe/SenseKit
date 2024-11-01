
import CoreLocation


public struct Heading {
  static public let zero: Heading = .init()
  
  public var trueHeading     : Measurement<UnitAngle>
  public var magneticHeading : Measurement<UnitAngle>
  public var headingAccuracy : Measurement<UnitAngle>
  
  public init() {
    self.trueHeading     = .zeroDegrees
    self.magneticHeading = .zeroDegrees
    self.headingAccuracy = .zeroDegrees
  }
  
  public init(from newHeading: CLHeading) {
    let trueHeading     = Measurement(value: newHeading.trueHeading.rounded(), unit: UnitAngle.degrees)
    let magneticHeading = Measurement(value: newHeading.magneticHeading.rounded(), unit: UnitAngle.degrees)
    let headingAccuracy = Measurement(value: newHeading.headingAccuracy.rounded(), unit: UnitAngle.degrees)
    
    self.trueHeading     = trueHeading
    self.magneticHeading = magneticHeading
    self.headingAccuracy = headingAccuracy
  }
}
