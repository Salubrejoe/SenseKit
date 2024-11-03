import Foundation

/// `Vector` is a generic class representing a vector in three-dimensional space.
/// It supports any `UnitType` conforming to `Dimension`, allowing for vectors of various physical quantities
/// (e.g., acceleration, magnetic field, angular velocity) using `Measurement` types.
///
/// - `UnitType`: A generic constraint requiring the vector's unit type to conform to `Dimension`.
///               This allows instances to support units like meters, degrees, radians, etc.
public class Vector<UnitType: Dimension>: Equatable {
  
  // MARK: - Typealiases
  /// Components of the vector represented as a tuple of `Double` values for the x, y, and z components.
  public typealias Components  = (x: Double, y: Double, z: Double)
  
  /// Components of the vector represented as a tuple of `String` descriptions, useful for formatted output.
  public typealias Descriptors = (x: String, y: String, z: String)
  
  
  // MARK: - Properties
  
  /// X component of the vector.
  var x: Measurement<UnitType>
  
  /// Y component of the vector.
  var y: Measurement<UnitType>
  
  /// Z component of the vector.
  var z: Measurement<UnitType>
  
  /// Returns a zero vector with each component (x, y, z) initialized to zero in the base unit of `UnitType`.
  static var zero: Vector {
    .init(x: .init(value: 0, unit: UnitType.baseUnit()),
          y: .init(value: 0, unit: UnitType.baseUnit()),
          z: .init(value: 0, unit: UnitType.baseUnit()))
  }
  
  
  // MARK: - Initializers
  
  /// Initializes a `Vector` with specified x, y, and z components.
  ///
  /// - Parameters:
  ///   - x: The x component of the vector as a `Measurement` of `UnitType`.
  ///   - y: The y component of the vector as a `Measurement` of `UnitType`.
  ///   - z: The z component of the vector as a `Measurement` of `UnitType`.
  public init(
    x: Measurement<UnitType>,
    y: Measurement<UnitType>,
    z: Measurement<UnitType>
  ) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  /// Initializes a `Vector` with zero components in the base unit of `UnitType`.
  public init() {
    let zero = Vector.zero
    self.x = zero.x
    self.y = zero.y
    self.z = zero.z
  }
  
  // MARK: - Polar Coordinates
  
  /// Returns the azimuth angle (angle in the x-y plane) in radians.
  public func azimuth() -> Measurement<UnitAngle> {
    let angle = atan2(y.value, x.value)
    return Measurement(value: angle, unit: .radians)
  }
  
  /// Returns the elevation angle (angle relative to the z-axis) in radians.
  public func elevation() -> Measurement<UnitAngle> {
    let magnitudeValue = self.magnitude().value
    guard magnitudeValue != 0 else {
      return Measurement(value: 0, unit: .radians)
    }
    let angle = acos(z.value / magnitudeValue)
    return Measurement(value: angle, unit: .radians)
  }
  
  // MARK: - Polar Coordinate Descriptions
  
  /// Returns polar coordinate descriptions in a tuple.
  ///
  /// - Parameters:
  ///   - significantDigits: The number of significant digits for each component.
  ///   - includeUnit: Whether to include the unit symbol in the description.
  /// - Returns: A tuple containing magnitude, azimuth, and elevation as formatted strings.
  public func polarCoordinatesDescription(significantDigits: Int = 2, includeUnit: Bool = true) -> (magnitude: String, azimuth: String, elevation: String) {
    let magnitudeString = magnitude().description(significantDigits: significantDigits, includeUnit: includeUnit)
    let azimuthString = azimuth().description(significantDigits: significantDigits, includeUnit: includeUnit)
    let elevationString = elevation().description(significantDigits: significantDigits, includeUnit: includeUnit)
    
    return (magnitude: magnitudeString, azimuth: azimuthString, elevation: elevationString)
  }

  
  
  // MARK: - Instance Methods
  
  /// Calculates the magnitude (length) of the vector.
  ///
  /// - Returns: A `Measurement` of `UnitType` representing the magnitude of the vector.
  public func magnitude() -> Measurement<UnitType> {
    let magnitudeValue = sqrt(pow(x.value, 2) + pow(y.value, 2) + pow(z.value, 2))
    return Measurement(value: magnitudeValue, unit: x.unit)
  }
  
  /// Adds the components of another vector to this vector.
  ///
  /// - Parameter other: The other vector to add.
  /// - Returns: A new `Vector` instance with the result of the addition.
  public func adding(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x + other.x,
      y: y + other.y,
      z: z + other.z
    )
  }
  
  /// Subtracts the components of another vector from this vector.
  ///
  /// - Parameter other: The other vector to subtract.
  /// - Returns: A new `Vector` instance with the result of the subtraction.
  public func subtracting(_ other: Vector<UnitType>) -> Vector<UnitType> {
    return Vector(
      x: x - other.x,
      y: y - other.y,
      z: z - other.z
    )
  }
  
  /// Rounds each component of the vector to a specified number of significant digits.
  ///
  /// - Parameter significantDigits: The number of significant digits to round to.
  /// - Returns: A `Components` tuple containing the rounded x, y, and z values.
  public func components(significantDigits: Int) -> Components {
    let xValue = x.value.roundTo(places: significantDigits)
    let yValue = y.value.roundTo(places: significantDigits)
    let zValue = z.value.roundTo(places: significantDigits)
    return (xValue, yValue, zValue)
  }
  
  /// Provides formatted string descriptions of each component with specified significant digits and optional unit symbols.
  ///
  /// - Parameters:
  ///   - significantDigits: The number of significant digits for each component.
  ///   - includeUnit: Whether to include the unit symbol in the description.
  /// - Returns: A `Descriptors` tuple containing the formatted string descriptions of x, y, and z.
  public func componentsDescriptions(significantDigits: Int = 2, includeUnit: Bool = true) -> Descriptors {
    let xString = x.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let yString = y.description(significantDigits: significantDigits, includeUnit: includeUnit)
    let zString = z.description(significantDigits: significantDigits, includeUnit: includeUnit)
    return (xString, yString, zString)
  }
  
  
  // MARK: - Equatable Conformance
  
  /// Checks for equality between two `Vector` instances based on their component values.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side vector.
  ///   - rhs: The right-hand side vector.
  /// - Returns: `true` if all components are equal, `false` otherwise.
  public static func == (lhs: Vector<UnitType>, rhs: Vector<UnitType>) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
}
