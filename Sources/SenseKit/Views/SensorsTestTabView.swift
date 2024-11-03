
import SwiftUI


public struct SensorsTestTabView: View {
  
  public init() {}
  
  public var body: some View {
    NavigationStack {
      TabView {
        MotionSensorTestForm()
          .navigationTitle("Device Motion")
          .tabItem {
            Label("Motion Sensor", systemImage: "gyroscope")
          }
        
        AltitudeTestForm()
          .navigationTitle("Barometer")
          .tabItem {
            Label("Altitude", systemImage: "mountain.2.fill")
          }
        
        LocationTestForm()
          .navigationTitle("GPS Location")
          .tabItem {
            Label("Location", systemImage: "location.circle")
          }
        
        ActivityTestForm()
          .navigationTitle("Actvity Manager")
          .tabItem {
            Label("Activity", systemImage: "figure.socialdance")
          }
      }
    }
  }
}
