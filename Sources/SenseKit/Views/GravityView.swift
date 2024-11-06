
import SwiftUI

public struct GravityView: View {
  
  @State var vector = SKVector(
    x: Measurement(value: 0.0, unit: UnitAcceleration.gravity),
    y: Measurement(value: 0.0, unit: UnitAcceleration.gravity),
    z: Measurement(value: 1.0, unit: UnitAcceleration.gravity)
  )
  
  public init() {}
  
  public var body: some View {
    SKCartesianVectorView(for: vector)
  }
}

#Preview {
  GravityView()
}