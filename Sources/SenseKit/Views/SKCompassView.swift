
import SwiftUI


public struct SKCompassView: View {
  
  let NSWEangles: [Angle] = [
    .degrees(0),
    .degrees(90),
    .degrees(180),
    .degrees(270)
  ]
  let multiplesOf30Degrees: [Angle] = [
    .degrees(30),
    .degrees(60),
    .degrees(120),
    .degrees(150),
    .degrees(210),
    .degrees(240),
    .degrees(300),
    .degrees(330)
    ]
  func generateMultiplesOf5Degrees(current: Angle, max: Angle) -> [Angle] {
    if current.degrees > max.degrees {
      return []
    }
    return [current] + generateMultiplesOf5Degrees(current: .degrees(current.degrees + 5), max: max)
  }

  var multiplesOf5Degrees: [Angle] {
    generateMultiplesOf5Degrees(current: .degrees(5), max: .degrees(360))
  }
  
  public var body: some View {
    ZStack {
      
      Circle().frame(width: 5, height: 5)
      Rectangle()
        .frame(width: 30, height: 2)
      Rectangle()
        .frame(width: 2, height: 30)
      
      Group {
        Text("N")
          .font(.title)
          .foregroundStyle(.pink)
          .offset(y: -150)
        Text("W")
          .font(.title)
          .offset(x: -150)
        Text("E")
          .font(.title)
          .offset(x: 150)
        Text("S")
          .font(.title)
          .offset(y: 150)
        
        
        NSWECapsules()
        multiplesOf30DegreesCapsules()
        multiplesOf5DegreesCapsules()
      }
      .skCompassModifier()
    }
  }
  
  
  private func NSWECapsules() -> some View {
    ForEach(NSWEangles, id: \.self) { angle in
      capsule(rotationEffect: angle, color: .accentColor)
        .frame(width: 2, height: 40)
    }
  }
  
  private func multiplesOf30DegreesCapsules() -> some View {
    ForEach(multiplesOf30Degrees, id: \.self) { angle in
      capsule(rotationEffect: angle, color: .indigo)
        .frame(width: 2, height: 20)
    }
  }
  
  private func multiplesOf5DegreesCapsules() -> some View {
    ForEach(multiplesOf5Degrees, id: \.self) { angle in
      capsule(rotationEffect: angle, color: .indigo)
        .frame(width: 2, height: 10)
    }
  }
  
  private func capsule(rotationEffect angle: Angle, color: Color = .primary) -> some View {
    Capsule(style: .continuous)
//      .fill(color.gradient.shadow(.inner(radius: 2)))
      .offset(y: -100)
      .rotationEffect(angle)
  }
}

#Preview {
  SKCompassView()
    .environment(SKLocation.stream)
}

