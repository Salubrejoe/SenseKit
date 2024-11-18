
import SwiftUI


struct SKTunerView: View {
  @State var 🎻 = AKConductor()
  
  var body: some View {
    VStack {
      Text("\(🎻.data.pitch, specifier: "%0.1f") hz")
      
      Spacer()
      
      Text("\(🎻.data.noteNameWithSharps)")
        .font(.system(size: 200))
        
      
      Spacer()
      
      NodeOutputView(🎻.tappableNodeB)
        .clipped()
      
    }
    .onAppear(perform: 🎻.start)
    .onDisappear(perform: 🎻.stop)
  }
}

#Preview {
  TunerView()
}
