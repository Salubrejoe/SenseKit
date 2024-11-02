
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
  private func section<Content: View>(
    _ title: String,
    vectorDescriptors: (String, String, String),
    magnitudeDescriptor: String,
    content: @escaping () -> Content
  ) -> some View {
    let (x, y, z) = vectorDescriptors
    
    Section(title) {
      content()
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
    ) {
      VectorView(vector: motionSensor.magnetometer)
        .frame(height: 100)
    }
  }
  
  private var attitudeSection: some View {
    section(
      "Attitude",
      vectorDescriptors: motionSensor.attitudeDescriptors(),
      magnitudeDescriptor: motionSensor.attitudeMagnitudeDescriptor()
    ) {
      VectorView(vector: motionSensor.attitude)
        .frame(height: 100)
    }
  }
  
  private var gravitySection: some View {
    section(
      "Gravity",
      vectorDescriptors: motionSensor.gravityDescriptors(),
      magnitudeDescriptor: motionSensor.gravityMagnitudeDescriptor()
    )  {
      VectorView(vector: motionSensor.gravity)
        .frame(height: 100)
    }
  }
  
  private var userAccelerationSection: some View {
    section(
      "User Acceleration",
      vectorDescriptors: motionSensor.userAccelerationDescriptors(),
      magnitudeDescriptor: motionSensor.userAccelerationMagnitudeDescriptor()
    )  {
      VectorView(vector: motionSensor.userAcceleration)
        .frame(height: 100)
    }
  }
  
  private var rotationRateSection: some View {
    section(
      "Rotation Rate",
      vectorDescriptors: motionSensor.rotationRateDescriptors(),
      magnitudeDescriptor: motionSensor.rotationRateMagnitudeDescriptor()
    )
    {
      VectorView(vector: motionSensor.rotationRate)
        .frame(height: 100)
    }
  }
}
