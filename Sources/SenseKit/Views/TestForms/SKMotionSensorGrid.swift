
import SwiftUI
import SenseKit


public struct SKMotionSensorGrid<Unit: Dimension>: View {
  @Environment(SKMotionSensor.self) var motion
  @Namespace var animation
  @State private var selected: SKVectorType?
  let columns: [GridItem] = [.init(.flexible())]
  
  public init(selected: SKVectorType? = nil) {
    self._selected = .init(initialValue: selected)
  }
  
  public var body: some View {
    LazyVGrid(columns: columns, spacing: 24) {
      
      if #available(iOS 18.0, *) {
        SKVectorCell(for: motion.attitude, nature: .attitude, selected: $selected)
          .matchedTransitionSource(id: motion.attitude.id, in: animation)
        
        SKVectorCell(for: motion.gravity, nature: .gravity, selected: $selected)
          .matchedTransitionSource(id: motion.gravity.id, in: animation)
        
        SKVectorCell(for: motion.userAcceleration, nature: .userAcceleration, selected: $selected)
          .matchedTransitionSource(id: motion.userAcceleration.id, in: animation)
        
        SKVectorCell(for: motion.magnetometerInGauss, nature: .magnetometer, selected: $selected)
          .matchedTransitionSource(id: motion.magnetometer.id, in: animation)
      } else {
        // Fallback on earlier versions
      }
    }
    .padding(.horizontal)
    .sheet(item: $selected) { type in
      skVectorViewSheet(for: type)
    }
  }
  
  @ViewBuilder
  private func skVectorViewSheet(for type: SKVectorType) -> some View {
    
    if #available(iOS 18.0, *) {
      Group {
        switch type {
        case .attitude:
          SKVectorView(for: motion.attitude, nature: .attitude)
            .navigationTransition(.zoom(sourceID: motion.attitude.id, in: animation))
        case .gravity:
          SKVectorView(for: motion.gravity, nature: .gravity)
            .navigationTransition(.zoom(sourceID: motion.gravity.id, in: animation))
        case .magnetometer:
          SKVectorView(for: motion.magnetometer, nature: .magnetometer)
            .navigationTransition(.zoom(sourceID: motion.magnetometer.id, in: animation))
        case .userAcceleration:
          SKVectorView(for: motion.userAcceleration, nature: .userAcceleration)
            .navigationTransition(.zoom(sourceID: motion.userAcceleration.id, in: animation))
        default:
          SKVectorView(for: .zeroDegrees, nature: .attitude)
            .navigationTransition(.zoom(sourceID: UUID(), in: animation))
        }
      }
      
    } else {
      // Fallback on earlier versions
    }
  }
}
