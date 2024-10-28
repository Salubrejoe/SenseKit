
import Foundation


public enum CoreMotionMode {
  case phone, headPhones
  
  mutating func toggle() {
    if self == .headPhones { self = .phone }
    else if self == .phone { self = .headPhones}
  }
}
