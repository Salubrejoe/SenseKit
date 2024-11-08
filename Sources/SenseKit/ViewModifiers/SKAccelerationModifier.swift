
import SwiftUI


public extension View {
  /// Applies a user acceleration effect to the view based on device motion, with customizable offset and scale.
  /// - Parameters:
  ///   - offsetAt1G: Maximum offset applied when experiencing 1G acceleration.
  ///   - zAxisScaleFactor: Factor for adjusting the scale based on Z-axis acceleration.
  ///   - animation: Animation type for smooth effect transitions.
  /// - Returns: A view with applied user acceleration effects.
  func skAccelerationModifier(offsetAt1G: CGFloat = 50, animation: Animation = .spring()) -> some View {
    modifier(SKAccelerationModifier(offsetAt1G: offsetAt1G, animation: animation))
  }
}


public struct SKAccelerationModifier: ViewModifier {
  
  @Environment(SKMotionSensor.self) var stream: SKMotionSensor?
  
  public let offsetAt1G: CGFloat
  public let animation: Animation
  
  @State var currentAcceleration: SKVector<UnitAcceleration> = .zero
  
  public func body(content: Content) -> some View {
    content
      .offset(size)
      .animation(animation, value: acceleration)
      .onChange(of: acceleration, calculateAcceleration)
  }
  
  private var acceleration: SKVector<UnitAcceleration> {
    stream?.userAcceleration ?? .init(x: .zeroMetersPerSecondsSquared, y: .zeroMetersPerSecondsSquared, z: .zeroMetersPerSecondsSquared)
  }
  
  private var size: CGSize {
    guard let stream else { return .zero }
    return CGSize(
      width:  acceleration.x.value,
      height: acceleration.y.value
    )
  }
  
  private func calculateAcceleration(_ oldValue: SKVector<UnitAcceleration>, _ newValue: SKVector<UnitAcceleration>) {
    currentAcceleration = acceleration
  }
}
