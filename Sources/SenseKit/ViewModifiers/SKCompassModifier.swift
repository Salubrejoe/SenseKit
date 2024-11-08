
import SwiftUI


public struct SKCompassModifier: ViewModifier {
  
  @Environment(SKLocation.self) var location: SKLocation?
  @State private var currentRotation: Angle
  
  public init(initialDisplacement angle: Angle = .degrees(.zero)) {
    self._currentRotation = .init(initialValue: angle)
  }
  
  public func body(content: Content) -> some View {
    content
      .rotationEffect(currentRotation)
      .onChange(of: locationHeading, calculateRotation)
  }
  
  private func calculateRotation(_ oldAngle: Angle, _ newAngle: Angle) {
    let delta = newAngle.degrees - oldAngle.degrees
    currentRotation -= .degrees(delta)
  }
  
  private var locationHeading: Angle {
    Angle(degrees: location?.heading.magneticHeading.value ?? .zero)
  }
}


public extension View {
  
  func skCompassModifier(initialDisplacement angle: Angle = .degrees(.zero)) -> some View {
    modifier(SKCompassModifier(initialDisplacement: angle))
  }
}

