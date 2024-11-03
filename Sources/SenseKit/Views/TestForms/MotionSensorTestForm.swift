
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
      CartesianVectorView(for: motionSensor.magnetometer)
        .frame(height: 200)
    }
  }
  
  private var attitudeSection: some View {
    section(
      "Attitude",
      vectorDescriptors: motionSensor.attitudeDescriptors(),
      magnitudeDescriptor: motionSensor.attitudeMagnitudeDescriptor()
    ) {
      CartesianVectorView(for: motionSensor.attitude)
        .frame(height: 200)
    }
  }
  
  private var gravitySection: some View {
    section(
      "Gravity",
      vectorDescriptors: motionSensor.gravityDescriptors(),
      magnitudeDescriptor: motionSensor.gravityMagnitudeDescriptor()
    )  {
      CartesianVectorView(for: motionSensor.gravity)
        .frame(height: 200)
    }
  }
  
  private var userAccelerationSection: some View {
    section(
      "User Acceleration",
      vectorDescriptors: motionSensor.userAccelerationDescriptors(),
      magnitudeDescriptor: motionSensor.userAccelerationMagnitudeDescriptor()
    )  {
      CartesianVectorView(for: motionSensor.userAcceleration)
        .frame(height: 200)
    }
  }
  
  private var rotationRateSection: some View {
    section(
      "Rotation Rate",
      vectorDescriptors: motionSensor.rotationRateDescriptors(),
      magnitudeDescriptor: motionSensor.rotationRateMagnitudeDescriptor()
    )
    {
      CartesianVectorView(for: motionSensor.rotationRate)
        .frame(height: 200)
    }
  }
}
