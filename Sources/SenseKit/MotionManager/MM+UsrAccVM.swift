
import Foundation


public extension MotionManager {
  
  func axisXOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let x = userAcceleration?.x else { return 0 }
    return maxOffset * x.value
  }
  
  func axisYOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let y = userAcceleration?.y else { return 0 }
    return -1 * maxOffset * y.value
  }
  
  func axisZScale(multiplier: CGFloat) -> CGFloat {
    guard let z = userAcceleration?.z else { return 0 }
    return 1 + (z.value * multiplier)
  }
}

public extension MotionManager {
  
  func magnAxisXOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let x = magnetometer?.x else { return 0 }
    return maxOffset * x.value/100
  }
  
  func magnAxisYOffset(max maxOffset: CGFloat) -> CGFloat {
    guard let y = magnetometer?.y else { return 0 }
    return -1 * maxOffset * y.value/100
  }
  
  func magnAxisZScale(multiplier: CGFloat) -> CGFloat {
    guard let z = magnetometer?.z else { return 0 }
    return 1 + (z.value * multiplier)
  }
}
