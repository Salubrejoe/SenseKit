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
    pitchFactor : CGFloat = 1,
    rollFactor  : CGFloat = 1,
    yawFactor   : CGFloat = 1,
    animation   : Animation = .spring(),
    normaliser  : SKAttitudeModifier.Normaliser? = nil
  ) -> some View {
    modifier(
      SKAttitudeModifier(
        pitchFactor: pitchFactor,
        rollFactor: rollFactor,
        yawFactor: yawFactor,
        animation: animation,
        normaliser: normaliser
      )
    )
  }
}

public struct SKAttitudeModifier: ViewModifier {
  public typealias Radians = Double
  public typealias Normaliser = (CGFloat) -> (CGFloat)
  
  @Environment(SKMotionSensor.self) var stream: SKMotionSensor?
  
  public let pitchFactor : CGFloat
  public let rollFactor  : CGFloat
  public let yawFactor   : CGFloat
  public let animation   : Animation
  
  public let normaliser : Normaliser?
  
  @State private var currentPitch : Radians = .zero
  @State private var currentRoll  : Radians = .zero
  @State private var currentYaw   : Radians = .zero
  
  public init(
    pitchFactor : CGFloat,
    rollFactor  : CGFloat,
    yawFactor   : CGFloat,
    animation   : Animation,
    normaliser  : Normaliser? = nil
  ) {
    self.pitchFactor = pitchFactor
    self.rollFactor  = rollFactor
    self.yawFactor   = yawFactor
    self.animation   = animation
    self.normaliser  = normaliser
  }
  
  public func body(content: Content) -> some View {
    content
      .rotation3DEffect(
        .radians(currentPitch * pitchFactor),
        axis: (x: 1, y: 0, z: 0),
        perspective: 0
      )
      .rotation3DEffect(
        .radians(currentRoll * rollFactor),
        axis: (x: 0, y: 1, z: 0),
        perspective: 0
      )
      .rotation3DEffect(
        .radians(currentYaw * yawFactor),
        axis: (x: 0, y: 0, z: 1),
        perspective: 0
      )
      .animation(animation, value: currentPitch)
      .animation(animation, value: currentRoll)
      .animation(animation, value: currentYaw)
      .onChange(of: attitude.x.value, calculatePitch)
      .onChange(of: attitude.y.value, calculateRoll)
      .onChange(of: attitude.z.value, calculateYaw)
  }
  
  private var pitch: Radians {
    var pitch: Radians = currentPitch * pitchFactor
    if let normaliser {
      return normaliser(pitch)
    }
    else {
      return pitch
    }
  }
  
  private var attitude: SKVector<UnitAngle> {
    stream?.attitude ?? .init(x: .zeroRadians, y: .zeroRadians, z: .zeroRadians)
  }
  
  private func calculatePitch(_ oldValue: Radians, _ newValue: Radians) {
    let delta = newValue - oldValue
    currentPitch -=  delta
  }
  
  private func calculateRoll(_ oldValue: Radians, _ newValue: Radians) {
    let delta = newValue - oldValue
    currentRoll -=  delta
  }
  
  private func calculateYaw(_ oldValue: Radians, _ newValue: Radians) {
    let delta = newValue - oldValue
    currentYaw -=  delta
  }
}
