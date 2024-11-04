
import SwiftUI
import CoreMotion


public struct ActivityTestForm: View {
  
  @Environment(SKActivityManager.self) var activityManager
  
  public var body: some View {
    Form {
      activitySection
    }
  }
  
  private var activitySection: some View {
    Section("Current Activity") {
      if let activity = activityManager.currentActivity {
        HStack(alignment: .firstTextBaseline) {
          Image(systemName: activity.activity.symbol)
          Text(activity.activity.description)
        }
        Text("From: \(activity.startDate.formatted(date: .omitted, time: .shortened))")
        Text("Confidence: \(confidenceDescription(for: activity.confidence))")
      } else {
        Text("No activity data available")
      }
    }
  }
  
  private func confidenceDescription(for confidence: CMMotionActivityConfidence) -> String {
    switch confidence {
    case .low:    return "Low"
    case .medium: return "Medium"
    case .high:   return "High"
    @unknown default: return "Unknown"
    }
  }
}
