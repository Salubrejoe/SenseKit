
import SwiftUI


extension View {
  
  public func userAccelerationEffect(maxOffset: CGFloat = 20, scaleMultiplier: CGFloat = 0.1, animation: Animation = .bouncy) -> some View {
    modifier(UserAccelerationEffect(maxOffset: maxOffset, scaleMultiplier: scaleMultiplier, animation: animation))
  }
}


public struct UserAccelerationEffect: ViewModifier {
  
  @Environment(MotionManager.self) var stream: MotionManager?
  
  let maxOffset: CGFloat
  let scaleMultiplier: CGFloat
  let animation: Animation
  
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

