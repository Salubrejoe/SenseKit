
import CoreMotion


struct Vector<UnitType: Dimension>: Equatable {
  
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
  
  func magnitude() -> Measurement<UnitType> {
    let magnitudeValue = sqrt(pow(x.value, 2) + pow(y.value, 2) + pow(z.value, 2))
    return Measurement(value: magnitudeValue, unit: x.unit)
  }
  
  func adding(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x + other.x,
      y: y + other.y,
      z: z + other.z
    )
  }
  
  func subtracting(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x - other.x,
      y: y - other.y,
      z: z - other.z
    )
  }
}
