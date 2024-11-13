
import SwiftUI


public extension View {
  /// Applies an offset to a View based on device acceleration, with an optional normalizer.
  ///
  /// - Parameters:
  ///   - offsetAt1G: The amount of offset applied per 1g acceleration. Default is 50.
  ///   - animation: The animation type for offset changes. Default is `.spring()`.
  ///   - normaliser: An optional closure to adjust the offset size before application.
  /// - Returns: A modified View with the SKAccelerationModifier applied.
  func skAccelerationModifier(
    offsetAt1G: CGFloat = 50,
    animation: Animation = .spring(),
    normaliser: SKAccelerationModifier.Normaliser? = nil
  ) -> some View {
    modifier(SKAccelerationModifier(offsetAt1G: offsetAt1G, animation: animation, normaliser: normaliser))
  }
}

// `SKAccelerationModifier` struct that applies an offset based on device's acceleration.
public struct SKAccelerationModifier: ViewModifier {
  
  // Type alias for the normalizer function.
  public typealias Normaliser = (CGSize) -> CGSize
  
  // Environment sensor providing acceleration information.
  @Environment(SKMotionSensor.self) var stream: SKMotionSensor?
  
  public let offsetAt1G: CGFloat
  public let animation: Animation
  public let normaliser: Normaliser?
  
  // State to store the current acceleration vector.
  @State private var currentOffset: CGSize = .zero
  
  /// Configures the offset effect on the `content` view.
  public func body(content: Content) -> some View {
    content
      .offset(finalOffset)
      .animation(animation, value: currentOffset)
      .onChange(of: acceleration, perform: { newValue in
        currentOffset = calculatedOffset
      }
      )
  }
  
  // Computed property to get the latest user acceleration data.
  private var acceleration: SKVector<UnitAcceleration> {
    stream?.userAcceleration ?? .zeroGs
  }
  
  // Computed property to calculate the offset size based on current acceleration.
  private var calculatedOffset: CGSize {
    guard let _ = stream else { return .zero }
    return CGSize(
      width:  acceleration.x.value * offsetAt1G,
      height: acceleration.y.value * offsetAt1G
    )
  }
  
  // Applies the normalizer if available, or returns the raw calculated offset.
  private var finalOffset: CGSize {
    if let normaliser {
      currentOffset = normaliser(currentOffset)
    }
    return currentOffset
  }
}
