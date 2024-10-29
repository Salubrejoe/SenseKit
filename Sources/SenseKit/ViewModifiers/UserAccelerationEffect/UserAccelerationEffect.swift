
import SwiftUI


public extension View {
  func userAccelerationEffect(maxOffset: CGFloat = 20, scaleMultiplier: CGFloat = 0.1, animation: Animation = .bouncy) -> some View {
    modifier(UserAccelerationEffect(maxOffset: maxOffset, scaleMultiplier: scaleMultiplier, animation: animation))
  }
}


public struct UserAccelerationEffect: ViewModifier {
  
  @Environment(MotionManager.self) var stream: MotionManager?
  
  public let maxOffset: CGFloat
  public let scaleMultiplier: CGFloat
  public let animation: Animation
  
  public func body(content: Content) -> some View {
    
    if let stream {
      
      content
        .scaleEffect(stream.axisZScale(multiplier: scaleMultiplier))
        .offset(
          x: stream.axisXOffset(max: maxOffset),
          y: stream.axisYOffset(max: maxOffset)
        )
        .animation(
          animation,
          value: stream.userAcceleration
        )
      
    } else {
      content
    }
  }
}
