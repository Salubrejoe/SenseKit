
import SwiftUI


public struct SensorsTestTabView: View {
  
  public init() {}
  
  public var body: some View {
    
    TabView {
      MotionSensorTestForm()
        .tabItem {
          Label("Motion Sensor", systemImage: "gyroscope")
        }
      
      AltitudeTestForm()
        .tabItem {
          Label("Altitude", systemImage: "mountain.2.fill")
        }
      
      LocationTestForm()
        .tabItem {
          Label("Location", systemImage: "location.circle")
        }
      
      ActivityTestForm()
        .tabItem {
          Label("Activity", systemImage: "figure.socialdance")
        }
    }
  }
}
