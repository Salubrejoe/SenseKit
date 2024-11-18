
import SwiftUI

public struct SKVectorView<Unit: Dimension>: View {
  @Environment(\.dismiss) var dismiss
  let vector: SKVector<Unit>
  let nature: SKVectorType
  
  public init(for vector: SKVector<Unit>, nature: SKVectorType) {
    self.vector = vector
    self.nature = nature
  }
  
  public var body: some View {
    
    NavigationStack {
      ZStack {
        SKCartesianVectorView(for: vector, scale: 1.0)
          .background(nature.color.gradient)
        
        VStack {
          Spacer()
          tableView()
            .padding(.horizontal)
        }
        .padding(.bottom)
      }
      .ignoresSafeArea()
      .navigationTitle(nature.rawValue.capitalized)
      .toolbar{toolbar}
    }
    .fontDesign(.rounded)
  }
  
  private func tableView() -> some View {
    VStack {
      cell(for: vector.x, title: "X")
      
      Divider()
      cell(for: vector.y, title: "Y")
      
      Divider()
      cell(for: vector.z, title: "Z")
      
      Divider()
      cell(for: vector.magnitude(), title: "Magnitude", foregroundColor: .pink)
      
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 30, style: .continuous)
        .fill(.ultraThinMaterial)
    )
  }
  
  private func cell(for measurment: Measurement<Unit>, title: String, foregroundColor color: Color? = nil) -> some View {
    HStack {
      Text(title)
      Spacer()
      Text(measurment.description())
        .foregroundStyle(color?.gradient ?? nature.color.gradient)
    }
  }
  
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var toolbar: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .symbolRenderingMode(.hierarchical)
      }
      .tint(nature.color)
    }
  }
}
