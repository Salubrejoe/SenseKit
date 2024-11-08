import SwiftUI

public extension View {
  /// Applies a rotation effect to the view based on device attitude, with customizable rotation factors for pitch, roll, and yaw.
  /// - Parameters:
  ///   - pitchFactor: Factor for adjusting the rotation based on pitch.
  ///   - rollFactor: Factor for adjusting the rotation based on roll.
  ///   - yawFactor: Factor for adjusting the rotation based on yaw.
  ///   - animation: Animation type for smooth effect transitions.
  /// - Returns: A view with applied attitude effects.
  func skAttitudeModifier(
    pitchFactor: CGFloat = 1,
    rollFactor: CGFloat = 1,
    yawFactor: CGFloat = 1,
    animation: Animation = .spring()
  ) -> some View {
    modifier(
      SKAttitudeModifier(
        pitchFactor: pitchFactor,
        rollFactor: rollFactor,
        yawFactor: yawFactor,
        animation: animation
      )
    )
  }
}

public struct SKAttitudeModifier: ViewModifier {
  
  @Environment(SKMotionSensor.self) var stream: SKMotionSensor?
  
  public let pitchFactor : CGFloat
  public let rollFactor  : CGFloat
  public let yawFactor   : CGFloat
  public let animation   : Animation
  
  @State private var currentAttitude: SKVector<UnitAngle> = .zero
  
  public func body(content: Content) -> some View {
    content
      .rotation3DEffect(
        .radians(currentAttitude.x.value * pitchFactor),
        axis: (x: 1, y: 0, z: 0),
        perspective: 0
      )
      .rotation3DEffect(
        .radians(currentAttitude.y.value * rollFactor),
        axis: (x: 0, y: 1, z: 0),
        perspective: 0
      )
      .rotation3DEffect(
        .radians(currentAttitude.z.value * yawFactor),
        axis: (x: 0, y: 0, z: 1),
        perspective: 0
      )
      .animation(animation, value: currentAttitude)
      .onChange(of: attitude, calculateAttitude)
  }
  
  private var attitude: SKVector<UnitAngle> {
    stream?.attitude ?? .init(x: .zeroRadians, y: .zeroRadians, z: .zeroRadians)
  }
  
  private func calculateAttitude(_ oldValue: SKVector<UnitAngle>, _ newValue: SKVector<UnitAngle>) {
    currentAttitude = attitude
  }
}
