
import SwiftUI


public extension View {
  func magnetEffect(maxOffset: CGFloat = 20, scaleMultiplier: CGFloat = 0.1, animation: Animation = .linear) -> some View {
    modifier(MagnetEffect(maxOffset: maxOffset, scaleMultiplier: scaleMultiplier, animation: animation))
  }
}


public struct MagnetEffect: ViewModifier {
  
  @Environment(MotionManager.self) var stream: MotionManager?
  
  public let maxOffset: CGFloat
  public let scaleMultiplier: CGFloat
  public let animation: Animation
  
  public func body(content: Content) -> some View {
    
    if let stream {
      
      content
        .scaleEffect(stream.magnAxisZScale(multiplier: scaleMultiplier))
        .offset(
          x: stream.magnAxisXOffset(max: maxOffset),
          y: stream.magnAxisYOffset(max: maxOffset)
        )
        .animation(
          animation,
          value: stream.magnetometer
        )
      
    } else {
      content
    }
  }
}
