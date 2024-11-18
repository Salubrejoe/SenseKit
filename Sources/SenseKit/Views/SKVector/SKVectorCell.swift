
import SwiftUI


public struct SKVectorCell<Unit: Dimension>: View {
  
  @Binding var selected: SKVectorType?
  let vector: SKVector<Unit>
  let nature: SKVectorType
  
  public init(
    for vector: SKVector<Unit>,
    nature: SKVectorType,
    selected: Binding<SKVectorType?>
  ) {
    self._selected = selected
    self.vector = vector
    self.nature = nature
  }
  
  public var body: some View {
    ZStack {
//      LinearGradient(colors: [nature.color, .secondary.opacity(0.3)], startPoint: .top, endPoint: .bottom)
      
      HStack {
        VStack {
          HStack {
            Label(title, systemImage: nature.image)
              .font(.headline).bold()
            Spacer()
          }
          
          Spacer()
          
          HStack(alignment: .firstTextBaseline) {
            Text(vector.magnitude().description(includeUnit: false))
              .font(.title.monospacedDigit())
              .fontWeight(.bold)
            Text(vector.x.unit.symbol)
              .font(.subheadline.monospacedDigit())
              .fontWeight(.semibold)
              .foregroundStyle(.secondary)
            Spacer()
          }
        }
        
        Spacer()
        
        SKCartesianVectorView(for: vector, scale: 1.0)
          .frame(width: 80, height: 80)
          .background(Circle().fill(.ultraThinMaterial).shadow(radius: 10))
      }
      .fontDesign(.rounded)
      .frame(maxWidth: .infinity)
      .padding()
    }
    .frame(height: 120)
    .onTapGesture {
      selected = nature
    }
    .background(RoundedRectangle(cornerRadius: 16, style: .circular).fill(nature.color.gradient))
  }
  
  private var title: String {
    nature.rawValue.capitalized
  }
  
}
