
import SwiftUI


public extension View {
  
  /// Applies a rotation effect to a View that mimics a compass rotation based on device heading.
  ///
  /// - Parameter angle: The initial displacement angle to offset the rotation. Default is `.zero`.
  /// - Returns: A modified View with the SKCompassModifier applied.
  func skCompassModifier(initialDisplacement angle: Angle = .degrees(.zero)) -> some View {
    modifier(SKCompassModifier(initialDisplacement: angle))
  }
}

// `SKCompassModifier` struct handles the rotation effect based on device's heading.
public struct SKCompassModifier: ViewModifier {
  
  // The location environment object providing heading information.
  @Environment(SKLocation.self) var location: SKLocation?
  
  // The current rotation applied to the view, adjusted by heading changes.
  @State private var currentRotation: Angle
  
  /// Initializes the `SKCompassModifier`.
  ///
  /// - Parameter angle: The initial displacement angle to offset the rotation.
  public init(initialDisplacement angle: Angle = .degrees(.zero)) {
    self._currentRotation = .init(initialValue: angle)
  }
  
  // Configures the rotation effect on the `content` view.
  public func body(content: Content) -> some View {
    content
      .rotationEffect(currentRotation)
      .onChange(of: locationHeading, calculateRotation)
  }
  
  // Updates the `currentRotation` state based on heading changes.
  //
  // - Parameters:
  //   - oldAngle: The previous heading angle.
  //   - newAngle: The updated heading angle.
  private func calculateRotation(_ oldAngle: Angle, _ newAngle: Angle) {
    let delta = newAngle.degrees - oldAngle.degrees
    currentRotation -= .degrees(delta)
  }
  
  // Retrieves the current magnetic heading from the location object.
  private var locationHeading: Angle {
    Angle(degrees: location?.heading.magneticHeading.value ?? .zero)
  }
}
