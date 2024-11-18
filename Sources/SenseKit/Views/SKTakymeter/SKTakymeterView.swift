
import SwiftUI
import SenseKit


public struct SKTakymeter: View {
  @Environment(SKLocation.self) var location
  
  public var body: some View {
    Gauge(value: speed.value, in: -1.0...150.0, label: {})
      .skTakymeterStyle(for: speed)
  }
  
  private var speed: Measurement<UnitSpeed> {
    .init(value: location.snapshot?.speed.value ?? 0.0, unit: .metersPerSecond)
  }
}

#Preview {
  SKTakymeter()
}

