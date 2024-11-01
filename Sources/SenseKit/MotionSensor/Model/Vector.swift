
import Foundation


public struct Vector<UnitType: Dimension>: Equatable {
  
  static var zero: Vector {
    .init(x: .init(value: 0, unit: UnitType.baseUnit()),
          y: .init(value: 0, unit: UnitType.baseUnit()),
          z: .init(value: 0, unit: UnitType.baseUnit()))
  }
  
  var x: Measurement<UnitType>
  var y: Measurement<UnitType>
  var z: Measurement<UnitType>
  
  
  public init(
    x: Measurement<UnitType>,
    y: Measurement<UnitType>,
    z: Measurement<UnitType>
  ) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  
  public init() {
    self = .zero
  }
  
  public func magnitude() -> Measurement<UnitType> {
    let magnitudeValue = sqrt(pow(x.value, 2) + pow(y.value, 2) + pow(z.value, 2))
    return Measurement(value: magnitudeValue, unit: x.unit)
  }
  
  public func adding(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x + other.x,
      y: y + other.y,
      z: z + other.z
    )
  }
  
  public func subtracting(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x - other.x,
      y: y - other.y,
      z: z - other.z
    )
  }
  
  public func componentsDescriptions(significantDigits: Int = 2, includeUnit: Bool = true) -> (x: String, y: String, z: String) {
    
    let xString = x.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let yString = y.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let zString = z.description(significantDigits: significantDigits, includeUnit: includeUnit)
    
    return (xString, yString, zString)
  }
  
  public func magnitudeDescription(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
  }
}
