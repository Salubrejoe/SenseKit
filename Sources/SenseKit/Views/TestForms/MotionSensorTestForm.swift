
import SwiftUI


public struct MotionSensorTestForm: View {
  
  @Environment(SKMotionSensor.self) var motionSensor
  
  public var body: some View {
    Form {
      section(vector: motionSensor.magnetometer)
      section(vector: motionSensor.userAcceleration)
      section(vector: motionSensor.gravity)
      section(vector: motionSensor.attitude)
      section(vector: motionSensor.rotationRate)
      section(vector: motionSensor.magneticField)
      
      Section("Heading") {
        Text("\(motionSensor.heading.description())")
      }
    }
  }
}

// MARK: - Sections
public extension MotionSensorTestForm {
  
  @ViewBuilder
  private func section<Units: Unit>(
    vector: SKVector<Units>
  ) -> some View {
    let (x, y, z) = vector.componentsDescriptions()
    
    Section(vector.title) {
      Text("X: \(x)")
      Text("Y: \(y)")
      Text("Z: \(z)")
      Text("Module: \(vector.magnitude().description())")
    }
  }
}
