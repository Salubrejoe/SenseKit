
import SwiftUI


public struct MotionSensorTestForm: View {
  
  @Environment(MotionSensor.self) var motionSensor
  
  public var body: some View {
    Form {
      magnetometerSection
      attitudeSection
      gravitySection
      userAccelerationSection
      rotationRateSection
    }
  }
}

// MARK: - Sections
public extension MotionSensorTestForm {
  
  @ViewBuilder
  private func section(
    _ title: String,
    vectorDescriptors: (String, String, String),
    magnitudeDescriptor: String
  ) -> some View {
    let (x, y, z) = vectorDescriptors
    
    Section(title) {
      Text("X: \(x)")
      Text("Y: \(y)")
      Text("Z: \(z)")
      Text("Magnitude: \(magnitudeDescriptor)")
    }
  }
  
  private var magnetometerSection: some View {
    section(
      "Magnetometer",
      vectorDescriptors: motionSensor.magneticFieldDescriptors(),
      magnitudeDescriptor: motionSensor.magneticFieldMagnitudeDescriptor()
    )
  }
  
  private var attitudeSection: some View {
    section(
      "Attitude",
      vectorDescriptors: motionSensor.attitudeDescriptors(),
      magnitudeDescriptor: motionSensor.attitudeMagnitudeDescriptor()
    )
  }
  
  private var gravitySection: some View {
    section(
      "Gravity",
      vectorDescriptors: motionSensor.gravityDescriptors(),
      magnitudeDescriptor: motionSensor.gravityMagnitudeDescriptor()
    )
  }
  
  private var userAccelerationSection: some View {
    section(
      "User Acceleration",
      vectorDescriptors: motionSensor.userAccelerationDescriptors(),
      magnitudeDescriptor: motionSensor.userAccelerationMagnitudeDescriptor()
    )
  }
  
  private var rotationRateSection: some View {
    section(
      "Rotation Rate",
      vectorDescriptors: motionSensor.rotationRateDescriptors(),
      magnitudeDescriptor: motionSensor.rotationRateMagnitudeDescriptor()
    )
  }
}
