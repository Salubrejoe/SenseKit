
import SwiftUI

struct GravityView: View {
  
  @State var vector = SKVector(
    x: Measurement(value: 0.0, unit: UnitAcceleration.gravity),
    y: Measurement(value: 0.0, unit: UnitAcceleration.gravity),
    z: Measurement(value: 1.0, unit: UnitAcceleration.gravity)
  )
  
  var body: some View {
    SKCartesianVectorView(
      for: vector,
      scale: 1.0,
      vectorColor: .blue
    )
  }
}

#Preview {
  GravityView()
}
