
import SwiftUI

public struct SKVectorView<Unit: Dimension>: View {
  
  let vector: SKVector<Unit>
  let nature: SKVectorType
  
  public init(for vector: SKVector<Unit>, nature: SKVectorType) {
    self.vector = vector
    self.nature = nature
  }
  
  public var body: some View {
    VStack {
      
      Text(nature.rawValue.capitalized)
        .font(.largeTitle)
      
      SKCartesianVectorView(for: vector, scale: 3.0)
        .frame(width: 300, height: 300)
        .clipShape(Circle())
        .shadow(radius: 10)
      
      let (x,y,z) = vector.componentsDescriptions()
      let magnitude = vector.magnitude().description()
      
      Text("x: \(x)")
      Text("y: \(y)")
      Text("z: \(z)")
      Text("Module: \(magnitude)")
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(nature.color.gradient)
  }
}
