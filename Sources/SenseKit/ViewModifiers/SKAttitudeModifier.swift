
import SwiftUI


public extension View {
  /// Applies a 3D attitude-based rotational effect to a View.
  ///
  /// - Parameters:
  ///   - pitchFactor: The multiplier for the pitch (vertical) rotation effect.
  ///   - rollFactor: The multiplier for the roll (horizontal) rotation effect.
  ///   - animation: The animation type applied to the rotational changes.
  ///   - normaliser: An optional closure to adjust the domain of the rotation values.
  /// - Returns: A modified View with the SKAttitudeModifier applied.
  func skAttitudeModifier(
    pitchFactor : CGFloat = 1,
    rollFactor  : CGFloat = 1,
    animation   : Animation = .spring(),
    normaliser  : SKAttitudeModifier.Normaliser? = nil
  ) -> some View {
    modifier(
      SKAttitudeModifier(
        pitchFactor: pitchFactor,
        rollFactor: rollFactor,
        animation: animation,
        normaliser: normaliser
      )
    )
  }
}

// `SKAttitudeModifier` applies 3D rotation based on the device's motion data.
public struct SKAttitudeModifier: ViewModifier {
  public typealias Radians = Double
  public typealias Normaliser = (CGFloat) -> (CGFloat)
  
  // The motion data stream providing attitude information.
  @Environment(SKMotionSensor.self) var stream: SKMotionSensor?
  
  public let pitchFactor : CGFloat
  public let rollFactor  : CGFloat
  public let animation   : Animation
  public let normaliser  : Normaliser?
  
  @State private var currentPitch : Radians = .zero
  @State private var currentRoll  : Radians = .zero
  
  // Initializer for `SKAttitudeModifier`.
  //
  // - Parameters:
  //   - pitchFactor: Multiplier for pitch (vertical tilt) effect.
  //   - rollFactor: Multiplier for roll (horizontal tilt) effect.
  //   - animation: Animation applied to the rotation changes.
  //   - normaliser: Optional closure to adjust the rotation values.
  public init(
    pitchFactor : CGFloat,
    rollFactor  : CGFloat,
    animation   : Animation,
    normaliser  : Normaliser? = nil
  ) {
    self.pitchFactor = pitchFactor
    self.rollFactor  = rollFactor
    self.animation   = animation
    self.normaliser  = normaliser
  }
  
  // Configures the 3D rotation effects on the `content` view.
  public func body(content: Content) -> some View {
    content
      .rotation3DEffect(
        .radians(pitch),
        axis: (x: 1, y: 0, z: 0),
        perspective: 0
      )
      .rotation3DEffect(
        .radians(roll),
        axis: (x: 0, y: 1, z: 0),
        perspective: 0
      )
      .animation(animation, value: pitch)
      .animation(animation, value: roll)
      .onChange(of: attitude.x.value, calculatePitch)
      .onChange(of: attitude.y.value, calculateRoll)
  }
  
  // Computed property for pitch, applying `pitchFactor` and optional normalization.
  private var pitch: Radians {
    var pitch: Radians = currentPitch * pitchFactor
    if let normaliser {
      return normaliser(pitch)
    }
    else {
      return pitch
    }
  }
  
  // Computed property for roll, applying `rollFactor` and optional normalization.
  private var roll: Radians {
    var roll: Radians = currentRoll * rollFactor
    if let normaliser {
      return normaliser(roll)
    }
    else {
      return roll
    }
  }
  
  // Computed property that retrieves the current attitude from the motion sensor.
  private var attitude: SKVector<UnitAngle> {
    stream?.attitude ?? .init(x: .zeroRadians, y: .zeroRadians, z: .zeroRadians)
  }
  
  // Updates the current pitch based on changes in attitude.
  //
  // - Parameters:
  //   - oldValue: The previous pitch value.
  //   - newValue: The updated pitch value.
  private func calculatePitch(_ oldValue: Radians, _ newValue: Radians) {
    let delta = newValue - oldValue
    currentPitch -= delta
  }
  
  // Updates the current roll based on changes in attitude.
  //
  // - Parameters:
  //   - oldValue: The previous roll value.
  //   - newValue: The updated roll value.
  private func calculateRoll(_ oldValue: Radians, _ newValue: Radians) {
    let delta = newValue - oldValue
    currentRoll -= delta
  }
}
