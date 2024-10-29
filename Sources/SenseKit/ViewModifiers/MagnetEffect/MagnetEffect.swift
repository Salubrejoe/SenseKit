
import SwiftUI


public extension View {
  func magnetEffect(maxOffset: CGFloat = 20) -> some View {
    modifier(MagnetEffect(maxOffset: maxOffset))
  }
}


public struct MagnetEffect: ViewModifier {
  
  @Environment(MotionManager.self) var stream: MotionManager?
  
  public let maxOffset: CGFloat
  
  public func body(content: Content) -> some View {
    
    if let stream {
      
      content
        .offset(
          x: stream.magnAxisXOffset(max: maxOffset),
          y: stream.magnAxisYOffset(max: maxOffset)
        )
        .animation(
          .linear,
          value: stream.magnetometer
        )
      
    } else {
      content
    }
  }
}
