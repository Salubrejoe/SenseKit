
import SwiftUI


public extension View {
  /// Applies a user acceleration effect to the view based on device motion, with customizable offset and scale.
  /// - Parameters:
  ///   - offsetAt1G: Maximum offset applied when experiencing 1G acceleration.
  ///   - zAxisScaleFactor: Factor for adjusting the scale based on Z-axis acceleration.
  ///   - animation: Animation type for smooth effect transitions.
  /// - Returns: A view with applied user acceleration effects.
  func userAccelerationEffect(offsetAt1G: CGFloat = 20, zAxisScaleFactor: CGFloat = 0.1, animation: Animation = .linear) -> some View {
    modifier(UserAccelerationEffect(offsetAt1G: offsetAt1G, zAxisScaleFactor: zAxisScaleFactor, animation: animation))
  }
}


public struct UserAccelerationEffect: ViewModifier {
  
  @Environment(MotionSensor.self) var stream: MotionSensor?
  
  public let offsetAt1G: CGFloat
  public let zAxisScaleFactor: CGFloat
  public let animation: Animation
  
  public func body(content: Content) -> some View {
    
    if let stream {
      
      content
        .offset(
          x: axisX(offsetAt1G),
          y: axisY(offsetAt1G)
        )
        .scaleEffect(axisZ(zAxisScaleFactor))
        .animation(
          animation,
          value: userAcceleration
        )
      
    } else {
      content
    }
  }
  
  private var userAcceleration: Vector<UnitAcceleration> {
    stream?.userAcceleration ?? Vector()
  }
  
  public func axisX(_ offset: CGFloat) -> CGFloat {
    offset * userAcceleration.x.value
  }
  
  public func axisY(_ offset: CGFloat) -> CGFloat {
    -1 * offset * userAcceleration.y.value
  }
  
  public func axisZ(_ factor: CGFloat) -> CGFloat {
    1 + (userAcceleration.z.value * factor)
  }
}
