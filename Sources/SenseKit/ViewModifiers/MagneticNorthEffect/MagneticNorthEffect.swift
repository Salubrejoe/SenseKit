
import SwiftUI


public extension View {
  func magneticNorthEffect(maxOffset: CGFloat = 20, animation: Animation = .bouncy) -> some View {
    modifier(MagneticNorthEffect(maxOffset: maxOffset, animation: animation))
  }
}

public struct MagneticNorthEffect: ViewModifier {
  
  @Environment(MotionSensor.self) var stream: MotionSensor?
  
//  public let maxOffset: CGFloat
  public let animation: Animation
  
  public func body(content: Content) -> some View {
    
    if let stream {
      content
        .rotation3DEffect(
          angleToNorth(),
          axis: (x: normalizedMagneticVector.y, y: -normalizedMagneticVector.x, z: 0)
        )
//        .offset(
//          x: axisXOffset(max: maxOffset),
//          y: axisYOffset(max: maxOffset)
//        )
        .animation(
          animation,
          value: magnetometer
        )
    } else {
      content
    }
  }
  
  private var magnetometer: Vector<UnitMagneticField> {
    stream?.magnetometer ?? Vector()
  }
  
  private var normalizedMagneticVector: (x: CGFloat, y: CGFloat) {
    // Calculate the magnitude of the magnetic field vector
    let magnitude = sqrt(pow(magnetometer.x.value, 2) + pow(magnetometer.y.value, 2))
    
    // Avoid division by zero; if magnitude is too low, return zero offsets
    guard magnitude > 0 else {
      return (x: 0, y: 0)
    }
    
    // Normalize the magnetic field values for the X and Y components
    return (
      x: magnetometer.x.value / magnitude,
      y: magnetometer.y.value / magnitude
    )
  }
  
  public func axisXOffset(max maxOffset: CGFloat) -> CGFloat {
    maxOffset * normalizedMagneticVector.x
  }
  
  public func axisYOffset(max maxOffset: CGFloat) -> CGFloat {
    -1 * maxOffset * normalizedMagneticVector.y
  }
  
  public func angleToNorth(_ multiplier: CGFloat = 1) -> Angle {
    // Calculate the angle in radians and apply the multiplier
    let angle = atan2(normalizedMagneticVector.y, normalizedMagneticVector.x)
    return Angle(radians: Double(angle) * Double(multiplier))
  }
}
