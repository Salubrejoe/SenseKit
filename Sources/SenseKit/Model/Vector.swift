
import CoreMotion


public struct Vector<UnitType: Dimension>: Equatable {
  
  static var zero: Vector {
    .init(x: .init(value: 0, unit: UnitType.baseUnit()),
          y: .init(value: 0, unit: UnitType.baseUnit()),
          z: .init(value: 0, unit: UnitType.baseUnit()))
  }
  
  var x: Measurement<UnitType>
  var y: Measurement<UnitType>
  var z: Measurement<UnitType>
  
  
  init(x: Measurement<UnitType>, y: Measurement<UnitType>, z: Measurement<UnitType>) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  
  init() {
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
  
  public func formattedComponents(significantDigits: Int = 2, includeUnit: Bool = true) -> (x: String, y: String, z: String) {
    
    let usableSignificantDigits = significantDigits > 0 ? significantDigits : 0
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = usableSignificantDigits
    formatter.minimumFractionDigits = usableSignificantDigits
    
    func formattedValue(_ measurement: Measurement<UnitType>) -> String {
      let value = abs(measurement.value)
      let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value))"
      return includeUnit ? "\(valueString) \(measurement.unit.symbol)" : valueString
    }
    
    let xString = formattedValue(x)
    let yString = formattedValue(y)
    let zString = formattedValue(z)
    
    return (xString, yString, zString)
  }
  
  public func formattedMagnitude(significantDigits: Int = 2, includeUnit: Bool = true) -> String {
    
    let usableSignificantDigits = significantDigits > 0 ? significantDigits : 0
    
    let magnitude = self.magnitude()
    let magnitudeValue = magnitude.value
    let magnitudeUnit  = magnitude.unit
    
    var returnValue = 0.0
    
    if significantDigits > 0 {
      returnValue = magnitudeValue.roundTo(places: usableSignificantDigits)
    } else {
      returnValue = magnitudeValue.rounded()
    }
    
    if includeUnit {
      return "\(returnValue.description) \(magnitude.unit.symbol)"
    }
    else {
      return returnValue.description
    }
  }
}
