
import Foundation


public extension MotionManager {
  
  func axisXOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let x = userAcceleration?.x else { return 0 }
    return maxOffset * x.value
  }
  
  public func axisYOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let y = userAcceleration?.y else { return 0 }
    return maxOffset * y.value
  }
  
  public func axisZScale(multiplier: CGFloat) -> CGFloat {
    guard let z = userAcceleration?.z else { return 0 }
    return 1 + (z.value * multiplier)
  }
}
