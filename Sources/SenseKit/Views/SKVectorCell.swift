
import SwiftUI


public struct SKVectorCell<Unit: Dimension>: View {
  
  @Binding var selected: SKVector<Unit>
  
  public var body: some View {
    Button {
      selected = icon
    } label: {
      Image(systemName: icon.id)
    }
    .foregroundStyle(icon.color.gradient)
    .font(.system(size: 100))
    .matchedTransitionSource(id: icon.id, in: animation)
  }
}

#Preview {
  SKVectorCell()
}
