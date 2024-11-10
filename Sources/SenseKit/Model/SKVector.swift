import SceneKit

/// `SKVector` is a generic class representing a vector in three-dimensional space.
/// It supports any `UnitType` conforming to `Dimension`, allowing for vectors of various physical quantities
/// (e.g., acceleration, magnetic field, angular velocity) using `Measurement` types.
///
/// - `UnitType`: A generic constraint requiring the vector's unit type to conform to `Dimension`.
///               This allows instances to support units like meters, degrees, radians, etc.

public class SKVector<UnitType: Dimension>: Equatable {
  
  // MARK: - Typealiases
  /// Components of the vector represented as a tuple of `Double` values for the x, y, and z components.
  public typealias Components  = (x: Double, y: Double, z: Double)
  
  /// Components of the vector represented as a tuple of `String` descriptions, useful for formatted output.
  public typealias Descriptors = (x: String, y: String, z: String)
  
  
  // MARK: - Properties
  
  /// X component of the vector.
  public var x: Measurement<UnitType>
  
  /// Y component of the vector.
  public var y: Measurement<UnitType>
  
  /// Z component of the vector.
  public var z: Measurement<UnitType>
  
  /// Returns a zero vector with each component (x, y, z) initialized to zero in the base unit of `UnitType`.
  static public var zero: SKVector {
    .init(x: .init(value: 0, unit: UnitType.baseUnit()),
          y: .init(value: 0, unit: UnitType.baseUnit()),
          z: .init(value: 0, unit: UnitType.baseUnit()))
  }
  
  
  // MARK: - Initializers
  
  /// Initializes a `SKVector` with specified x, y, and z components.
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
  
  /// Initializes a `SKVector` with zero components in the base unit of `UnitType`.
  public init() {
    let zero = SKVector.zero
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
  public func adding(_ other: SKVector<UnitType>) -> SKVector<UnitType> {
    return SKVector(
      x: x + other.x,
      y: y + other.y,
      z: z + other.z
    )
  }
  
  /// Subtracts the components of another vector from this vector.
  ///
  /// - Parameter other: The other vector to subtract.
  /// - Returns: A new `Vector` instance with the result of the subtraction.
  public func subtracting(_ other: SKVector<UnitType>) -> SKVector<UnitType> {
    return SKVector(
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
  
  
  
  // MARK: - NORMALISATION
  /// Returns a new vector with components normalized to ensure the magnitude falls within a given range.
  /// - Parameters:
  ///   - range: A closed range specifying the desired magnitude bounds (e.g., 0.1...1.0).
  /// - Returns: A new `SKVector` instance with components scaled to ensure the magnitude falls within the specified range.
  public func normalized(toRange range: ClosedRange<Double>) -> SKVector<UnitType> {
    let currentMagnitude = magnitude().value
    
    // Check if the magnitude is already within the range
    if range.contains(currentMagnitude) {
      return self // No scaling needed
    }
    
    // Determine the target magnitude within the range (use min or max depending on the current magnitude)
    let targetMagnitude = currentMagnitude < range.lowerBound ? range.lowerBound : range.upperBound
    
    // Calculate the scaling factor
    let scale = targetMagnitude / currentMagnitude
    
    // Scale each component by the scaling factor
    let scaledX = Measurement(value: x.value * scale, unit: x.unit)
    let scaledY = Measurement(value: y.value * scale, unit: y.unit)
    let scaledZ = Measurement(value: z.value * scale, unit: z.unit)
    
    // Return the normalized vector
    return SKVector(x: scaledX, y: scaledY, z: scaledZ)
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
  public static func == (lhs: SKVector<UnitType>, rhs: SKVector<UnitType>) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
}


// MARK: - SCNQuaternion

public extension SKVector  {
  
  /// Calculates a quaternion to represent the orientation of the vector relative to the x-axis
  func quaternion(relativeTo reference: SCNVector3 = SCNVector3(0,1,0)) -> SCNQuaternion {
    
    let scnVector = SCNVector3(self.x.value, self.y.value, self.z.value)
    
    // Normalize the vectors
    let vMagnitude = scnVector.magnitude
    let rMagnitude = reference.magnitude
    
    let normalizedV = SCNVector3(
      scnVector.x / vMagnitude,
      scnVector.y / vMagnitude,
      scnVector.z / vMagnitude
    )
    
    let normalizedR = SCNVector3(
      reference.x / rMagnitude,
      reference.y / rMagnitude,
      reference.z / rMagnitude
    )
    
    
    // Calculate the dot product and angle
    let dotProduct = normalizedV.x * normalizedR.x +
    normalizedV.y * normalizedR.y +
    normalizedV.z * normalizedR.z
    let angle = acos(dotProduct)
    
    // Calculate the axis of rotation (cross product)
    let axisX = normalizedV.y * normalizedR.z - normalizedV.z * normalizedR.y
    let axisY = normalizedV.z * normalizedR.x - normalizedV.x * normalizedR.z
    let axisZ = normalizedV.x * normalizedR.y - normalizedV.y * normalizedR.x
    
    // Normalize the axis vector
    let axisMagnitude = sqrt(axisX * axisX + axisY * axisY + axisZ * axisZ)
    let unitAxisX = axisX / axisMagnitude
    let unitAxisY = axisY / axisMagnitude
    let unitAxisZ = axisZ / axisMagnitude
    
    // Calculate quaternion components
    let halfAngleSin = sin(angle / 2)
    let qx = unitAxisX * halfAngleSin
    let qy = unitAxisY * halfAngleSin
    let qz = unitAxisZ * halfAngleSin
    let qw = cos(angle / 2)
    
    return SCNQuaternion(qx, qy, qz, qw)
  }
}


// MARK: - String Properties
public extension SKVector {
  
  var title: String {
    switch x.unit.self {
    case is UnitAcceleration:
      "Acceleration"
      case is UnitAngularVelocity:
      "Angular Velocity"
    case is UnitMagneticField:
      "Magnetic Field"
    case is UnitLength:
      "Length"
    case is UnitMass:
      "Mass"
    case is UnitPower:
      "Power"
    case is UnitAngle:
      "Attitude"
    default:
      "Unknown"
    }
  }
}
