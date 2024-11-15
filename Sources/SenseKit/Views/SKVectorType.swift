
import SwiftUI


public enum SKVectorType: String, Identifiable {
  case attitude
  case gravity
  case userAcceleration
  case magnetifField
  case rotationRate
  case magnetometer
  
  public var id: String { rawValue }
  
  public var image: String {
    switch self {
    case .attitude:
      "gyroscope"
    case .gravity:
      "arrow.down.circle"
    case .userAcceleration:
      "speedometer"
    case .magnetifField:
      "waveform.path.ecg"
    case .rotationRate:
      "arrow.3.trianglepath"
    case .magnetometer:
      "magnifyingglass"
    }
  }
  
  public var color: Color {
    switch self {
    case .attitude:
        .blue
    case .gravity:
        .green
    case .userAcceleration:
        .orange
    case .magnetifField:
        .purple
    case .rotationRate:
        .yellow
    case .magnetometer:
        .red
    }
  }
}
