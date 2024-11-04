
import SwiftUI


public extension View {
  func magneticNorthEffect(animation: Animation = .bouncy) -> some View {
    modifier(MagneticNorthEffect(animation: animation))
  }
}

public struct MagneticNorthEffect: ViewModifier {
  
  @Environment(SKLocation.self) var stream: SKLocation?
  
  public let animation: Animation
  
  public func body(content: Content) -> some View {
    
    if let stream {
      content
        .rotationEffect(headingAngle, anchor: .bottom)
        .animation(
          animation,
          value: headingAngle
        )
    } else {
      content
    }
  }
  
  private var headingAngle: Angle {
    Angle(degrees: rawHeading)
  }
  
  private var rawHeading: Double {
    stream?.heading.magneticHeading.value ?? 0.0
  }
}
