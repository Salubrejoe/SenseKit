
import Foundation


public class Vector<UnitType: Dimension>: Equatable {
  public static func == (lhs: Vector<UnitType>, rhs: Vector<UnitType>) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
  
  public typealias Components  = (x: Double, y: Double, z: Double)
  public typealias Descriptors = (x: String, y: String, z: String)
  
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
    let zero = Vector.zero
    self.x = zero.x
    self.y = zero.y
    self.z = zero.z
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
  
  public func components(significantDigits: Int) -> Components {
    let xValue = x.value.roundTo(places: significantDigits)
    let yValue = y.value.roundTo(places: significantDigits)
    let zValue = z.value.roundTo(places: significantDigits)
    return (xValue, yValue, zValue)
  }
  
  public func componentsDescriptions(significantDigits: Int = 2, includeUnit: Bool = true) -> Descriptors {
    
    let xString = x.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let yString = y.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let zString = z.description(significantDigits: significantDigits, includeUnit: includeUnit)
    return (xString, yString, zString)
  }
}

