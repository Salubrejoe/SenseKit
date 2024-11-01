
import SwiftUI


public struct MotionSensorTestForm: View {
  
//  @Environment(MotionSensor.self) var motionSensor
//  @Environment(Location.self) var location
  @State private var motionSensor = MotionSensor.stream
//  @State private var location = Location.stream
  
  public var body: some View {
    Form {
      // Magnetometer Section
      let (xm, ym, zm) = motionSensor.magneticFieldDescriptor()
      
      Section("Magnetometer") {
        Text("X: \(xm)")
        Text("Y: \(ym)")
        Text("Z: \(zm)")
        Text("Magnitude: \(motionSensor.magneticFieldMagnitudeDescriptor())")
      }
      
      // Attitude Section
      let (xa, ya, za) = motionSensor.attitudeDescriptors()
      
      Section("Attitude") {
        Text("X: \(xa)")
        Text("Y: \(ya)")
        Text("Z: \(za)")
        Text("Magnitude: \(motionSensor.attitudeMagnitudeDescriptor())")
      }
      
      // Gravity Section
      let (xg, yg, zg) = motionSensor.gravityDescriptors()
      
      Section("Gravity") {
        Text("X: \(xg)")
        Text("Y: \(yg)")
        Text("Z: \(zg)")
        Text("Magnitude: \(motionSensor.gravityMagnitudeDescriptors())")
      }
      
      // User Acceleration Section
      let (xua, yua, zua) = motionSensor.userAccelerationDescriptor()
      
      Section("User Acceleration") {
        Text("X: \(xua)")
        Text("Y: \(yua)")
        Text("Z: \(zua)")
        Text("Magnitude: \(motionSensor.userAccelerationMagnitudeDescriptors())")
      }
      
      // Rotation Rate Section
      let (xrr, yrr, zrr) = motionSensor.rotationRateDescriptors()
      
      Section("Rotation Rate") {
        Text("X: \(xrr)")
        Text("Y: \(yrr)")
        Text("Z: \(zrr)")
        Text("Magnitude: \(motionSensor.rotationRateMagnitudeDescriptor())")
      }
      
      // Location Data
//      if let location = location.snapshot {
//        Section("Location") {
//          Text("Latitude: \(location.coordinates.latitude.description)")
//          Text("Longitude: \(location.coordinates.longitude.description)")
//          Text("Uncertainty Radius: \(location.coordinates.uncertaintyRadius.description)")
//          Text("Altitude: \(location.altitude.altitude.description)")
//          Text("Ellipsoidal Altitude: \(location.altitude.ellipsoidalAltitude.description)")
//          Text("Vertical Uncertainty: \(location.altitude.verticalUncertainty.description)")
//          Text("Floor: \(location.floor ?? -666)")
//          Text("Speed: \(location.speed.value.formatted()) m/s")
//          Text("Speed Accuracy: \(location.speedAccuracy.value.formatted()) m/s")
//        }
//      } else {
//        Section("Location") {
//          Text("Location data not available")
//        }
//      }
      
      // Heading Section
//      Text("Heading: \(location.heading.magneticHeading.value)°")
    }
  }
}
