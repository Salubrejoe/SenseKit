
import SwiftUI


public extension View {
  func skTakymeterStyle(for speed: Measurement<UnitSpeed>) -> some View {
    gaugeStyle(TJTakymeterStyle(speed: speed))
  }
}

public struct SKTakymeterStyle: GaugeStyle {
  
  let speed: Measurement<UnitSpeed>
  
  public func makeBody(configuration: Configuration) -> some View {
    
    GeometryReader { geometry in
      
      let width = geometry.size.width
      let padding = width/15
      let lineWidth = width/27
      let textSize = width/3.6
      let smallTextSize = textSize/3
      
      let value = configuration.value
      
      ZStack {
        
        mainCircle(value: value, opacity: 1, lineWidth: lineWidth)
          .padding(padding)
        
        mainCircle(value: 1, opacity: 0.2, lineWidth: lineWidth)
          .padding(padding)
        
        Text(speedString)
          .font(
            .system(
              size: textSize,
              design: .rounded
            )
            .monospacedDigit()
          )
        
        VStack {
          
          Spacer()
          
          Text(speedUnit)
            .font(.system(size: smallTextSize, weight: .semibold, design: .rounded))
            .foregroundColor(.secondary)
        }
        .frame(width: width/2.5)
        .padding(.bottom, padding)
      }
      .frame(height: width)
    }
  }
  
  private var speedValue: Double {
    speed.value
  }
  
  private var speedUnit: String {
    speed.unit.symbol
  }
  
  private var speedString: String {
    String(format: "%.0f", speedValue)
  }
  
  private func strokeStyle(lineWidth: CGFloat) -> StrokeStyle {
    StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
  }
  
  private var angularGradient: AngularGradient {
    .init(gradient: Gradient(colors: [.cyan, .blue, .purple, .pink]), center: .center, startAngle: .degrees(-10), endAngle: .degrees(350))
  }
  
  private func mainCircle(value: Double, opacity: Double, lineWidth: Double) -> some View {
    Circle()
      .trim(from: 0, to: 0.80 * value)
      .stroke(angularGradient.opacity(opacity), style: strokeStyle(lineWidth: lineWidth))
      .rotationEffect(.degrees(125))
  }
}


