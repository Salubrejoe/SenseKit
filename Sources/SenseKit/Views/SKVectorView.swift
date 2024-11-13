
import SwiftUI

public struct SKVectorView<Unit: Dimension>: View {
  
  @Binding var vector: SKVector<Unit>
  
  public init() {}
  
  public var body: some View {
    SKCartesianVectorView(for: vector)
  }
}

#Preview {
  SKVectorView()
}
